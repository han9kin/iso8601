/*
 *  NJISO8601Parser.re
 *  NJISO8601
 *
 *  Created by han9kin on 2012-03-21.
 *  Copyright (c) 2012 NHN. All rights reserved.
 *
 */

#import "NJISO8601ParserDef.h"


id NJISO8601ParseString(NSString *aString, NSString **aError);


static int NJIntFromString(const unsigned char *aString, int aDigits)
{
    int sValue = 0;

    for (int i = 0; i < aDigits; i++)
    {
        sValue  *= 10;
        sValue  += (*aString - '0');
        aString += 1;
    }

    return sValue;
}


static double NJFractionFromString(const unsigned char *aString, int aDigits)
{
    double sValue = 0.0;
    double sBase  = 1.0;

    for (int i = 0; i < aDigits; i++)
    {
        sBase   *= 10;
        sValue  += (*aString - '0') / sBase;
        aString += 1;
    }

    return sValue;
}


static BOOL NJIsLeapYear(int aYear)
{
    if ((((aYear % 4) == 0) && ((aYear % 100) != 0)) || ((aYear % 400) == 0))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


static BOOL NJGetGregorianDateFromOrdinalDate(CFGregorianDate *aGregorianDate, int aYear, int aDayOfYear)
{
    static int  sDays365[] = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 };
    static int  sDays366[] = { 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335 };
    int        *sDays;

    if (NJIsLeapYear(aYear))
    {
        sDays = sDays366;
    }
    else
    {
        sDays = sDays365;
    }

    for (int i = 11; i >= 0; i--)
    {
        if (aDayOfYear > sDays[i])
        {
            aGregorianDate->year  = aYear;
            aGregorianDate->month = i + 1;
            aGregorianDate->day   = aDayOfYear - sDays[i];

            return YES;
        }
    }

    return NO;
}


static int NJDayOfYearFromWeekDate(int *aYear, int aWeek, int aDayOfWeek)
{
    /*
     * Algorithm from http://en.wikipedia.org/wiki/ISO_week_date#Calculating_a_date_given_the_year.2C_week_number_and_weekday
     */

    CFGregorianDate sDateOfJan4;
    int             sWeekdayOfJan4;
    int             sDayOfYear;

    sDateOfJan4.year   = *aYear;
    sDateOfJan4.month  = 1;
    sDateOfJan4.day    = 4;
    sDateOfJan4.hour   = 0;
    sDateOfJan4.minute = 0;
    sDateOfJan4.second = 0.0;

    sWeekdayOfJan4 = CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(sDateOfJan4, NULL), NULL);
    sDayOfYear     = aWeek * 7 + aDayOfWeek - (sWeekdayOfJan4 + 3);

    if (sDayOfYear <= 0)
    {
        *aYear     = *aYear - 1;
        sDayOfYear = ((NJIsLeapYear(*aYear)) ? 366 : 365) - sDayOfYear;
    }
    else
    {
        int sDaysOfYear = NJIsLeapYear(*aYear) ? 366 : 365;

        if (sDayOfYear > sDaysOfYear)
        {
            *aYear     = *aYear + 1;
            sDayOfYear = sDayOfYear - sDaysOfYear;
        }
    }

    return sDayOfYear;
}


static CFTimeInterval NJMidnightCorrectionWithGregorianDate(CFGregorianDate *aGregorianDate)
{
    if ((aGregorianDate->hour == 24) && (aGregorianDate->minute == 0) && (aGregorianDate->second == 0.0))
    {
        aGregorianDate->hour = 0;

        return (CFTimeInterval)24 * 60 * 60;
    }
    else
    {
        return (CFTimeInterval)0;
    }
}


static NSDate *NJDateFromGregorianDateWithLocalTimeZone(CFGregorianDate aGregorianDate, NSString **aError)
{
    CFTimeInterval sMidnightCorrection = NJMidnightCorrectionWithGregorianDate(&aGregorianDate);

    if (CFGregorianDateIsValid(aGregorianDate, kCFGregorianAllUnits))
    {
        CFAbsoluteTime sAbsoluteTime = CFGregorianDateGetAbsoluteTime(aGregorianDate, (CFTimeZoneRef)[NSTimeZone localTimeZone]);

        return [NSDate dateWithTimeIntervalSinceReferenceDate:(sAbsoluteTime + sMidnightCorrection)];
    }
    else
    {
        *aError = @"Invalid gregorian calendar unit.";

        return nil;
    }
}


static NSDate *NJDateFromGregorianDateWithTimeZoneOffset(CFGregorianDate aGregorianDate, double aTimeZoneOffset, NSString **aError)
{
    CFTimeInterval sMidnightCorrection = NJMidnightCorrectionWithGregorianDate(&aGregorianDate);

    if (CFGregorianDateIsValid(aGregorianDate, kCFGregorianAllUnits))
    {
        CFAbsoluteTime sAbsoluteTime = CFGregorianDateGetAbsoluteTime(aGregorianDate, NULL);

        return [NSDate dateWithTimeIntervalSinceReferenceDate:(sAbsoluteTime + sMidnightCorrection - aTimeZoneOffset)];
    }
    else
    {
        *aError = @"Invalid gregorian calendar unit.";

        return nil;
    }
}


#define NJISO8601ParseGetCondition()           sCondition
#define NJISO8601ParseSetCondition(aCondition) sCondition = aCondition


id NJISO8601ParseString(NSString *aString, NSString **aError)
{
    NSString            *sError = nil;
    CFGregorianDate      sGregorianDate;
    CFTimeInterval       sTimeZoneOffset;
    const unsigned char *sMatch;
    const unsigned char *sCursor;
    const unsigned char *sMarker;
    int                  sCondition;

    sCursor    = (const unsigned char *)[aString UTF8String];
    sCondition = kNJISO8601ConditionStart;

    while (1)
    {
        sMatch = sCursor;

        /*!re2c

        re2c:define:YYCTYPE        = "unsigned char";
        re2c:define:YYCURSOR       = sCursor;
        re2c:define:YYMARKER       = sMarker;
        re2c:define:YYCONDTYPE     = NJISO8601Condition;
        re2c:define:YYGETCONDITION = NJISO8601ParseGetCondition;
        re2c:define:YYSETCONDITION = NJISO8601ParseSetCondition;
        re2c:condprefix            = NJISO8601Condition;
        re2c:condenumprefix        = kNJISO8601Condition;
        re2c:yych:conversion       = 0;
        re2c:yyfill:enable         = 0;
        re2c:indent:top            = 2;
        re2c:indent:string         = "    ";


        ANY     = [^];
        NULL    = "\000";

        SIGN    = ("+"|"-");
        DIGIT   = [0-9];

        HYPHEN  = "-";
        COLON   = ":";
        COMMA   = (","|".");
        SOLIDUS = "/";

        D       = "D";
        H       = "H";
        M       = "M";
        P       = "P";
        R       = "R";
        S       = "S";
        T       = "T";
        W       = "W";
        Y       = "Y";
        Z       = "Z";


        <Start> P => DurationBegin
            {
                continue;
            }

        <Start> R => RecurringIntervalBegin
            {
                continue;
            }

        <Start> ANY => DateBegin
            {
                sCursor--;
                continue;
            }


        <DateBegin> DIGIT{4} HYPHEN DIGIT{2} HYPHEN DIGIT{2} => DateEnd
            {
                sGregorianDate.year  = NJIntFromString(sMatch, 4);
                sGregorianDate.month = NJIntFromString(sMatch + 5, 2);
                sGregorianDate.day   = NJIntFromString(sMatch + 8, 2);
                continue;
            }

        <DateBegin> DIGIT{4} HYPHEN DIGIT{2} => DateEnd
            {
                sGregorianDate.year  = NJIntFromString(sMatch, 4);
                sGregorianDate.month = NJIntFromString(sMatch + 5, 2);
                sGregorianDate.day   = 1;
                continue;
            }

        <DateBegin> DIGIT{4} DIGIT{2} DIGIT{2} => DateEnd
            {
                sGregorianDate.year  = NJIntFromString(sMatch, 4);
                sGregorianDate.month = NJIntFromString(sMatch + 4, 2);
                sGregorianDate.day   = NJIntFromString(sMatch + 6, 2);
                continue;
            }

        <DateBegin> DIGIT{4} => DateEnd
            {
                sGregorianDate.year  = NJIntFromString(sMatch, 4);
                sGregorianDate.month = 1;
                sGregorianDate.day   = 1;
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN DIGIT{2} HYPHEN DIGIT{2} => DateEnd
            {
                int sYearDigits      = sCursor - sMatch - 7;
                sGregorianDate.year  = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                sGregorianDate.month = NJIntFromString(sMatch + sYearDigits + 2, 2);
                sGregorianDate.day   = NJIntFromString(sMatch + sYearDigits + 5, 2);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN DIGIT{2} => DateEnd
            {
                int sYearDigits      = sCursor - sMatch - 4;
                sGregorianDate.year  = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                sGregorianDate.month = NJIntFromString(sMatch + sYearDigits + 2, 2);
                sGregorianDate.day   = 1;
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} DIGIT{2} DIGIT{2} => DateEnd
            {
                int sYearDigits      = sCursor - sMatch - 5;
                sGregorianDate.year  = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                sGregorianDate.month = NJIntFromString(sMatch + sYearDigits + 1, 2);
                sGregorianDate.day   = NJIntFromString(sMatch + sYearDigits + 3, 2);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} => DateEnd
            {
                int sYearDigits      = sCursor - sMatch - 1;
                sGregorianDate.year  = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                sGregorianDate.month = 1;
                sGregorianDate.day   = 1;
                continue;
            }

        <DateBegin> DIGIT{4} HYPHEN DIGIT{3} => DateEnd
            {
                int sYear      = NJIntFromString(sMatch, 4);
                int sDayOfYear = NJIntFromString(sMatch + 5, 3);
                if (NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear))
                {
                    continue;
                }
                else
                {
                    sError = @"Invalid ordinal date.";
                    break;
                }
            }

        <DateBegin> DIGIT{4} DIGIT{3} => DateEnd
            {
                int sYear      = NJIntFromString(sMatch, 4);
                int sDayOfYear = NJIntFromString(sMatch + 4, 3);
                if (NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear))
                {
                    continue;
                }
                else
                {
                    sError = @"Invalid ordinal date.";
                    break;
                }
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN DIGIT{3} => DateEnd
            {
                int sYearDigits = sCursor - sMatch - 5;
                int sYear       = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                int sDayOfYear  = NJIntFromString(sMatch + sYearDigits + 2, 3);
                if (NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear))
                {
                    continue;
                }
                else
                {
                    sError = @"Invalid ordinal date.";
                    break;
                }
            }

        <DateBegin> DIGIT{4} HYPHEN W DIGIT{2} HYPHEN DIGIT{1} => DateEnd
            {
                int sYear      = NJIntFromString(sMatch, 4);
                int sWeek      = NJIntFromString(sMatch + 6, 2);
                int sDayOfWeek = NJIntFromString(sMatch + 9, 1);
                int sDayOfYear = NJDayOfYearFromWeekDate(&sYear, sWeek, sDayOfWeek);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> DIGIT{4} HYPHEN W DIGIT{2} => DateEnd
            {
                int sYear      = NJIntFromString(sMatch, 4);
                int sWeek      = NJIntFromString(sMatch + 6, 2);
                int sDayOfYear = NJDayOfYearFromWeekDate(&sYear, sWeek, 1);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> DIGIT{4} W DIGIT{2} DIGIT{1} => DateEnd
            {
                int sYear      = NJIntFromString(sMatch, 4);
                int sWeek      = NJIntFromString(sMatch + 5, 2);
                int sDayOfWeek = NJIntFromString(sMatch + 7, 1);
                int sDayOfYear = NJDayOfYearFromWeekDate(&sYear, sWeek, sDayOfWeek);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> DIGIT{4} W DIGIT{2} => DateEnd
            {
                int sYear      = NJIntFromString(sMatch, 4);
                int sWeek      = NJIntFromString(sMatch + 5, 2);
                int sDayOfYear = NJDayOfYearFromWeekDate(&sYear, sWeek, 1);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN W DIGIT{2} HYPHEN DIGIT{1} => DateEnd
            {
                int sYearDigits = sCursor - sMatch - 7;
                int sYear       = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                int sWeek       = NJIntFromString(sMatch + sYearDigits + 3, 2);
                int sDayOfWeek  = NJIntFromString(sMatch + sYearDigits + 6, 1);
                int sDayOfYear  = NJDayOfYearFromWeekDate(&sYear, sWeek, sDayOfWeek);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} HYPHEN W DIGIT{2} => DateEnd
            {
                int sYearDigits = sCursor - sMatch - 5;
                int sYear       = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                int sWeek       = NJIntFromString(sMatch + sYearDigits + 3, 2);
                int sDayOfYear  = NJDayOfYearFromWeekDate(&sYear, sWeek, 1);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} W DIGIT{2} DIGIT{1} => DateEnd
            {
                int sYearDigits = sCursor - sMatch - 5;
                int sYear       = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                int sWeek       = NJIntFromString(sMatch + sYearDigits + 2, 2);
                int sDayOfWeek  = NJIntFromString(sMatch + sYearDigits + 4, 1);
                int sDayOfYear  = NJDayOfYearFromWeekDate(&sYear, sWeek, sDayOfWeek);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }

        <DateBegin> SIGN DIGIT{4,} W DIGIT{2} => DateEnd
            {
                int sYearDigits = sCursor - sMatch - 4;
                int sYear       = NJIntFromString(sMatch + 1, sYearDigits) * ((*sMatch == '+') ? 1 : -1);
                int sWeek       = NJIntFromString(sMatch + sYearDigits + 2, 2);
                int sDayOfYear  = NJDayOfYearFromWeekDate(&sYear, sWeek, 1);
                NJGetGregorianDateFromOrdinalDate(&sGregorianDate, sYear, sDayOfYear);
                continue;
            }


        <DateEnd> T => TimeBegin
            {
                continue;
            }

        <DateEnd> SOLIDUS
            {
                sError = @"ISO8601 Time Interval not supported yet.";
                break;
            }

        <DateEnd> NULL
            {
                sGregorianDate.hour   = 0;
                sGregorianDate.minute = 0;
                sGregorianDate.second = 0;

                return NJDateFromGregorianDateWithLocalTimeZone(sGregorianDate, aError);
            }


        <TimeBegin> DIGIT{2} COLON DIGIT{2} COLON DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                int sFractionDigits    = sCursor - sMatch - 9;
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 3, 2);
                sGregorianDate.second  = NJIntFromString(sMatch + 6, 2);
                sGregorianDate.second += NJFractionFromString(sMatch + 9, sFractionDigits);
                continue;
            }

        <TimeBegin> DIGIT{2} COLON DIGIT{2} COLON DIGIT{2} => TimeEnd
            {
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 3, 2);
                sGregorianDate.second  = NJIntFromString(sMatch + 6, 2);
                continue;
            }

        <TimeBegin> DIGIT{2} COLON DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                int sFractionDigits    = sCursor - sMatch - 6;
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 3, 2);
                sGregorianDate.second  = NJFractionFromString(sMatch + 6, sFractionDigits) * 60.0;
                continue;
            }

        <TimeBegin> DIGIT{2} COLON DIGIT{2} => TimeEnd
            {
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 3, 2);
                sGregorianDate.second  = 0;
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                int sFractionDigits    = sCursor - sMatch - 7;
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 2, 2);
                sGregorianDate.second  = NJIntFromString(sMatch + 4, 2);
                sGregorianDate.second += NJFractionFromString(sMatch + 7, sFractionDigits);
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} DIGIT{2} => TimeEnd
            {
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 2, 2);
                sGregorianDate.second  = NJIntFromString(sMatch + 4, 2);
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                int sFractionDigits    = sCursor - sMatch - 5;
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 2, 2);
                sGregorianDate.second  = NJFractionFromString(sMatch + 5, sFractionDigits) * 60.0;
                continue;
            }

        <TimeBegin> DIGIT{2} DIGIT{2} => TimeEnd
            {
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = NJIntFromString(sMatch + 2, 2);
                sGregorianDate.second  = 0;
                continue;
            }

        <TimeBegin> DIGIT{2} COMMA DIGIT{1,} => TimeEnd
            {
                int    sFractionDigits = sCursor - sMatch - 3;
                double sFraction       = NJFractionFromString(sMatch + 3, sFractionDigits);
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = floor(sFraction * 60.0);
                sGregorianDate.second  = (sFraction * 60.0 - sGregorianDate.minute) * 60.0;
                continue;
            }

        <TimeBegin> DIGIT{2} => TimeEnd
            {
                sGregorianDate.hour    = NJIntFromString(sMatch, 2);
                sGregorianDate.minute  = 0;
                sGregorianDate.second  = 0;
                continue;
            }


        <TimeEnd> Z => TimeZoneBegin
            {
                sCursor--;
                continue;
            }

        <TimeEnd> SIGN => TimeZoneBegin
            {
                sCursor--;
                continue;
            }

        <TimeEnd> SOLIDUS
            {
                sError = @"ISO8601 Time Interval not supported yet.";
                break;
            }

        <TimeEnd> NULL
            {
                return NJDateFromGregorianDateWithLocalTimeZone(sGregorianDate, aError);
            }


        <TimeZoneBegin> Z => TimeZoneEnd
            {
                sTimeZoneOffset = 0;
                continue;
            }

        <TimeZoneBegin> SIGN DIGIT{2} COLON DIGIT{2} => TimeZoneEnd
            {
                sTimeZoneOffset  = NJIntFromString(sMatch + 1, 2) * 60 * 60 + NJIntFromString(sMatch + 4, 2) * 60;
                sTimeZoneOffset *= (*sMatch == '+') ? 1.0 : -1.0;
                continue;
            }

        <TimeZoneBegin> SIGN DIGIT{2} DIGIT{2} => TimeZoneEnd
            {
                sTimeZoneOffset  = NJIntFromString(sMatch + 1, 2) * 60 * 60 + NJIntFromString(sMatch + 3, 2) * 60;
                sTimeZoneOffset *= (*sMatch == '+') ? 1.0 : -1.0;
                continue;
            }

        <TimeZoneBegin> SIGN DIGIT{2} => TimeZoneEnd
            {
                sTimeZoneOffset  = NJIntFromString(sMatch + 1, 2) * 60 * 60;
                sTimeZoneOffset *= (*sMatch == '+') ? 1.0 : -1.0;
                continue;
            }


        <TimeZoneEnd> SOLIDUS
            {
                sError = @"ISO8601 Time Interval not supported yet.";
                break;
            }

        <TimeZoneEnd> NULL
            {
                return NJDateFromGregorianDateWithTimeZoneOffset(sGregorianDate, sTimeZoneOffset, aError);
            }


        <DurationBegin> ANY
            {
                sError = @"ISO8601 Duration not supported yet.";
                break;
            }


        <RecurringIntervalBegin> ANY
            {
                sError = @"ISO8601 Recurring Time Interval not supported yet.";
                break;
            }


        <*> NULL
            {
                sError = @"Unexpected end of string.";
                break;
            }

        <*> ANY
            {
                sError = @"Unexpected character.";
                break;
            }

        */
    }

    if (aError)
    {
        *aError = sError;
    }

    return nil;
}

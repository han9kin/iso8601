/*
 *  NJISO8601Formatter.m
 *  NJISO8601
 *
 *  Created by han9kin on 2012-03-21.
 *  Copyright (c) 2012 NHN. All rights reserved.
 *
 */

#import "NJISO8601Formatter.h"


id NJISO8601ParseString(NSString *aString, NSString **aError);


static BOOL NJISO8601GetObjectFromString(id *aObject, NSString *aString, NSString **aError)
{
    NSString *sError = nil;
    id        sObject;

    if (aString)
    {
        sObject = NJISO8601ParseString(aString, &sError);
    }
    else
    {
        sObject = nil;
        sError  = @"Null string.";
    }

    if (sObject)
    {
        if (aObject)
        {
            *aObject = sObject;
        }

        return YES;
    }
    else
    {
        if (aError)
        {
            *aError = sError;
        }

        return NO;
    }
}


NSDate *NJISO8601DateFromString(NSString *aString)
{
    if (aString)
    {
        id sObject;

        if (NJISO8601GetObjectFromString(&sObject, aString, NULL))
        {
            return [sObject isKindOfClass:[NSDate class]] ? sObject : nil;
        }
    }

    return nil;
}


@implementation NJISO8601Formatter
{
    NJISO8601FormatterDateStyle      mDateStyle;
    NJISO8601FormatterTimeStyle      mTimeStyle;
    int                              mTimeFractionDigits;
    NJISO8601FormatterTimeZoneStyle  mTimeZoneStyle;
    NSTimeZone                      *mTimeZone;
}


@synthesize dateStyle          = mDateStyle;
@synthesize timeStyle          = mTimeStyle;
@synthesize timeFractionDigits = mTimeFractionDigits;
@synthesize timeZoneStyle      = mTimeZoneStyle;
@synthesize timeZone           = mTimeZone;


- (void)dealloc
{
    [mTimeZone release];
    [super dealloc];
}


- (NSString *)stringForObjectValue:(id)aObject
{
    if ([aObject isKindOfClass:[NSDate class]])
    {
        return [self stringFromDate:aObject];
    }
    else
    {
        return nil;
    }
}


- (BOOL)getObjectValue:(id *)aObject forString:(NSString *)aString errorDescription:(NSString **)aError
{
    return NJISO8601GetObjectFromString(aObject, aString, aError);
}


- (NSDate *)dateFromString:(NSString *)aString
{
    return NJISO8601DateFromString(aString);
}


- (NSString *)stringFromDate:(NSDate *)aDate
{
    if (aDate)
    {
        NSMutableString *sString;
        NSTimeZone      *sTimeZone;
        CFGregorianDate  sGregorianDate;

        sString = [NSMutableString string];

        if (mTimeZoneStyle == NJISO8601FormatterTimeZoneStyleUTC)
        {
            sTimeZone = nil;
        }
        else
        {
            sTimeZone = mTimeZone ? mTimeZone : [NSTimeZone localTimeZone];
        }

        sGregorianDate = CFAbsoluteTimeGetGregorianDate([aDate timeIntervalSinceReferenceDate], (CFTimeZoneRef)sTimeZone);

        if ((sGregorianDate.year < 0) || (sGregorianDate.year > 9999))
        {
            [sString appendFormat:@"%+05d", sGregorianDate.year];
        }
        else
        {
            [sString appendFormat:@"%04d", sGregorianDate.year];
        }

        switch (mDateStyle)
        {
            case NJISO8601FormatterDateStyleCalendarExtended:
                [sString appendFormat:@"-%02d-%02d", sGregorianDate.month, sGregorianDate.day];
                break;
            case NJISO8601FormatterDateStyleCalendarBasic:
                [sString appendFormat:@"%02d%02d", sGregorianDate.month, sGregorianDate.day];
                break;
            default:
                /*
                 * not supported date style
                 */
                return nil;
                break;
        }

        switch (mTimeStyle)
        {
            case NJISO8601FormatterTimeStyleExtended:
                [sString appendFormat:@"T%02d:%02d:", sGregorianDate.hour, sGregorianDate.minute];
                break;
            case NJISO8601FormatterTimeStyleBasic:
                [sString appendFormat:@"T%02d%02d", sGregorianDate.hour, sGregorianDate.minute];
                break;
            case NJISO8601FormatterTimeStyleNone:
                /*
                 * skip remaining part
                 */
                return sString;
                break;
        }

        if (mTimeFractionDigits > 0)
        {
            NSString *sSecondString = [NSString stringWithFormat:@"%0*.*lf", (mTimeFractionDigits + 3), mTimeFractionDigits, sGregorianDate.second];

            [sString appendFormat:@"%@,%@", [sSecondString substringToIndex:2], [sSecondString substringFromIndex:3]];
        }
        else
        {
            [sString appendFormat:@"%02.0lf", sGregorianDate.second];
        }

        switch (mTimeZoneStyle)
        {
            case NJISO8601FormatterTimeZoneStyleUTC:
                [sString appendFormat:@"Z"];
                break;

            case NJISO8601FormatterTimeZoneStyleExtended:
            case NJISO8601FormatterTimeZoneStyleBasic:
                {
                    NSInteger sOffset = [sTimeZone secondsFromGMT] / 60; /* minutes from GMT */

                    if (sOffset < 0)
                    {
                        [sString appendFormat:@"-"];
                        sOffset *= -1;
                    }
                    else
                    {
                        [sString appendFormat:@"+"];
                    }

                    [sString appendFormat:@"%02d", (sOffset / 60)];

                    if (mTimeZoneStyle == NJISO8601FormatterTimeZoneStyleExtended)
                    {
                        [sString appendFormat:@":"];
                    }

                    [sString appendFormat:@"%02d", (sOffset % 60)];
                }
                break;

            case NJISO8601FormatterTimeZoneStyleNone:
                break;
        }

        return sString;
    }
    else
    {
        return nil;
    }
}


@end

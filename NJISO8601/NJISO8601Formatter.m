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


@interface NJISO8601Formatter ()
{
    NJISO8601FormatterDateStyle          mDateStyle;
    NJISO8601FormatterTimeStyle          mTimeStyle;
    NJISO8601FormatterTimeZoneStyle      mTimeZoneStyle;
    NJISO8601FormatterFractionSeparator  mFractionSeparator;
    int                                  mFractionDigits;
    NSTimeZone                          *mTimeZone;
}

@end


@implementation NJISO8601Formatter (Formatting)


- (void)appendDateStringWithYear:(int)aYear month:(int)aMonth day:(int)aDay toString:(NSMutableString *)aString
{
    if ((aYear < 0) || (aYear > 9999))
    {
        [aString appendFormat:@"%+05d", aYear];
    }
    else
    {
        [aString appendFormat:@"%04d", aYear];
    }

    if (mDateStyle == NJISO8601FormatterDateStyleCalendarExtended)
    {
        [aString appendFormat:@"-%02d-%02d", aMonth, aDay];
    }
    else
    {
        [aString appendFormat:@"%02d%02d", aMonth, aDay];
    }
}


- (void)appendTimeStringWithHour:(int)aHour minute:(int)aMinute second:(double)aSecond toString:(NSMutableString *)aString
{
    if (mTimeStyle == NJISO8601FormatterTimeStyleExtended)
    {
        [aString appendFormat:@"T%02d:%02d:", aHour, aMinute];
    }
    else
    {
        [aString appendFormat:@"T%02d%02d", aHour, aMinute];
    }

    if (mFractionDigits > 0)
    {
        [aString appendFormat:@"%0*.*lf", (mFractionDigits + 3), mFractionDigits, aSecond];

        if (mFractionSeparator == NJISO8601FormatterFractionSeparatorComma)
        {
            [aString replaceCharactersInRange:NSMakeRange([aString length] - mFractionDigits - 1, 1) withString:@","];
        }
    }
    else
    {
        [aString appendFormat:@"%02.0lf", aSecond];
    }
}


- (void)appendTimeZoneStringForTimeZone:(NSTimeZone *)aTimeZone toString:(NSMutableString *)aString
{
    if (mTimeZoneStyle == NJISO8601FormatterTimeZoneStyleNone)
    {
    }
    else if (mTimeZoneStyle == NJISO8601FormatterTimeZoneStyleUTC)
    {
        [aString appendFormat:@"Z"];
    }
    else
    {
        NSInteger sMinutesFromGMT = [aTimeZone secondsFromGMT] / 60;

        if (sMinutesFromGMT < 0)
        {
            sMinutesFromGMT *= -1;

            [aString appendFormat:@"-%02d", (sMinutesFromGMT / 60)];
        }
        else
        {
            [aString appendFormat:@"+%02d", (sMinutesFromGMT / 60)];
        }

        if (mTimeZoneStyle == NJISO8601FormatterTimeZoneStyleExtended)
        {
            [aString appendFormat:@":%02d", (sMinutesFromGMT % 60)];
        }
        else
        {
            [aString appendFormat:@"%02d", (sMinutesFromGMT % 60)];
        }
    }
}


@end


@implementation NJISO8601Formatter


@synthesize dateStyle         = mDateStyle;
@synthesize timeStyle         = mTimeStyle;
@synthesize timeZoneStyle     = mTimeZoneStyle;
@synthesize fractionSeparator = mFractionSeparator;
@synthesize fractionDigits    = mFractionDigits;
@synthesize timeZone          = mTimeZone;


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

        [self appendDateStringWithYear:sGregorianDate.year month:sGregorianDate.month day:sGregorianDate.day toString:sString];

        if (mTimeStyle != NJISO8601FormatterTimeStyleNone)
        {
            [self appendTimeStringWithHour:sGregorianDate.hour minute:sGregorianDate.minute second:sGregorianDate.second toString:sString];
            [self appendTimeZoneStringForTimeZone:sTimeZone toString:sString];
        }

        return sString;
    }
    else
    {
        return nil;
    }
}


@end

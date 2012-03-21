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


- (NSString *)stringForObjectValue:(id)aObject
{
    return nil;
}


- (BOOL)getObjectValue:(id *)aObject forString:(NSString *)aString errorDescription:(NSString **)aError
{
    return NJISO8601GetObjectFromString(aObject, aString, aError);
}


- (NSDate *)dateFromString:(NSString *)aString
{
    return NJISO8601DateFromString(aString);
}


@end

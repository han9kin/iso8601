/*
 *  NJISO8601Formatter.h
 *  NJISO8601
 *
 *  Created by han9kin on 2012-03-21.
 *  Copyright (c) 2012 NHN. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


typedef enum
{
    NJISO8601FormatterDateStyleCalendarExtended = 0,    /* Default           (YYYY-MM-DD) */
    NJISO8601FormatterDateStyleCalendarBasic,           /*                   (YYYYMMDD)   */
    NJISO8601FormatterDateStyleOrdinalExtended,         /* Not supported yet (YYYY-DDD)   */
    NJISO8601FormatterDateStyleOrdinalBasic,            /* Not supported yet (YYYYDDD)    */
    NJISO8601FormatterDateStyleWeekExtended,            /* Not supported yet (YYYY-Www-D) */
    NJISO8601FormatterDateStyleWeekBasic,               /* Not supported yet (YYYYWwwD)   */
} NJISO8601FormatterDateStyle;


typedef enum
{
    NJISO8601FormatterTimeStyleExtended = 0,            /* Default           (hh:mm:ss)   */
    NJISO8601FormatterTimeStyleBasic,                   /*                   (hhmmss)     */
    NJISO8601FormatterTimeStyleNone,
} NJISO8601FormatterTimeStyle;


typedef enum
{
    NJISO8601FormatterTimeZoneStyleUTC = 0,             /* Default           (Z)          */
    NJISO8601FormatterTimeZoneStyleExtended,            /*                   (±hh:mm)     */
    NJISO8601FormatterTimeZoneStyleBasic,               /*                   (±hhmm)      */
    NJISO8601FormatterTimeZoneStyleNone,
} NJISO8601FormatterTimeZoneStyle;


NSDate *NJISO8601DateFromString(NSString *aString);


@interface NJISO8601Formatter : NSFormatter


@property(nonatomic, assign) NJISO8601FormatterDateStyle      dateStyle;
@property(nonatomic, assign) NJISO8601FormatterTimeStyle      timeStyle;
@property(nonatomic, assign) int                              timeFractionDigits;
@property(nonatomic, assign) NJISO8601FormatterTimeZoneStyle  timeZoneStyle;
@property(nonatomic, retain) NSTimeZone                      *timeZone;


- (NSDate *)dateFromString:(NSString *)aString;
- (NSString *)stringFromDate:(NSDate *)aDate;


@end

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
#if 0
    NJISO8601FormatterDateStyleOrdinalExtended,         /* Not supported yet (YYYY-DDD)   */
    NJISO8601FormatterDateStyleOrdinalBasic,            /* Not supported yet (YYYYDDD)    */
    NJISO8601FormatterDateStyleWeekExtended,            /* Not supported yet (YYYY-Www-D) */
    NJISO8601FormatterDateStyleWeekBasic,               /* Not supported yet (YYYYWwwD)   */
#endif
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


typedef enum
{
    NJISO8601FormatterFractionSeparatorComma = 0,       /* Default           (,)          */
    NJISO8601FormatterFractionSeparatorDot,             /* Default           (.)          */
} NJISO8601FormatterFractionSeparator;


NSDate *NJISO8601DateFromString(NSString *aString);


@interface NJISO8601Formatter : NSFormatter


@property(nonatomic, assign) NJISO8601FormatterDateStyle          dateStyle;
@property(nonatomic, assign) NJISO8601FormatterTimeStyle          timeStyle;
@property(nonatomic, assign) NJISO8601FormatterTimeZoneStyle      timeZoneStyle;
@property(nonatomic, assign) NJISO8601FormatterFractionSeparator  fractionSeparator;
@property(nonatomic, assign) int                                  fractionDigits;
@property(nonatomic, retain) NSTimeZone                          *timeZone;


- (NSDate *)dateFromString:(NSString *)aString;
- (NSString *)stringFromDate:(NSDate *)aDate;


@end

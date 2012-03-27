NSFormatter for ISO 8601
========================

A Cocoa NSFormatter subclass for converting ISO 8601 formatted string to NSDate, and vice versa.

The parser is implemented using [re2c](http://re2c.org).
Thanks to [re2c](http://re2c.org), it is much faster than NSDateFormatter is.


Supported Formats
-----------------

* Calendar Date
* Ordinal Date
* Week Date
* Local Time with Decimal Fractions
* Midnight
* Time Zone

Unsupported Formats
-------------------

* BC Date
* Basic Format of Ordinal Date Expanded Representation (Year > 9999)
* Local Time with Leap Second (Second >= 60.0)
* Time Inverval
* Duration
* Recurring Time Interval


Usage
-----

To convert ISO 8601 string to NSDate. You can use *NJISO8601DateFromString()* function without any configuration.

    NSDate *date = NJISO8601DateFromString(@"2011-02-27T11:03:06+09:00");

or, you can use the NJISO8601Formatter the same way as you do with NSDateFormatter.

    NJISO8601Formatter *formatter = [[NJISO8601Formatter alloc] init];

    NSDate *date = [formatter dateFromString:@"2011-02-07T11:03:06+09:00"];

To convert NSDate to ISO 8601 formatted string.

    NJISO8601Formatter *formatter = [[NJISO8601Formatter alloc] init];

    NSString *string = [formatter stringFromDate:date];

Also, you can customize output format like this:

    [formatter setDateStyle:NJISO8601FormatterDateStyleWeekExtended];
    [formatter setTimeZoneStyle:NJISO8601FormatterTimeZoneStyleExtended];
    [formatter setFractionSeparator:NJISO8601FormatterFractionSeparatorDot];
    [formatter setFractionDigits:6];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(8 * 60 * 60)]];

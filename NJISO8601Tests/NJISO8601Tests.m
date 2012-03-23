//
//  NJISO8601Tests.m
//  NJISO8601Tests
//
//  Created by 서 상혁 on 2012-03-21.
//  Copyright (c) 2012년 NHN. All rights reserved.
//

#import "NJISO8601Tests.h"
#import "NJISO8601Formatter.h"
#import "ISO8601DateFormatter.h"


static NSString *gTestStrings[][2] =
{
    { @"2011-02-07T19:03:46,123456+09:00", @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+0900",  @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+09",    @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456",       @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+08:00", @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+0800",  @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456+08",    @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46,123456Z",      @"2011-02-07T19:03:46,123+0000" },

    { @"2011-02-07T19:03:46.123+09:00",    @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+0900",     @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+09",       @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123",          @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+08:00",    @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+0800",     @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123+08",       @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T19:03:46.123Z",         @"2011-02-07T19:03:46,123+0000" },

    { @"2011-02-07T190346,123+09:00",      @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123+0900",       @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123+09",         @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123",            @"2011-02-07T10:03:46,123+0000" },
    { @"2011-02-07T190346,123+08:00",      @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T190346,123+0800",       @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T190346,123+08",         @"2011-02-07T11:03:46,123+0000" },
    { @"2011-02-07T190346,123Z",           @"2011-02-07T19:03:46,123+0000" },

    { @"2011-02-07T19:03:46+09:00",        @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46+0900",         @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46+09",           @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46",              @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T19:03:46+08:00",        @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T19:03:46+0800",         @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T19:03:46+08",           @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T19:03:46Z",             @"2011-02-07T19:03:46,000+0000" },

    { @"2011-02-07T190346+09:00",          @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346+0900",           @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346+09",             @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346",                @"2011-02-07T10:03:46,000+0000" },
    { @"2011-02-07T190346+08:00",          @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T190346+0800",           @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T190346+08",             @"2011-02-07T11:03:46,000+0000" },
    { @"2011-02-07T190346Z",               @"2011-02-07T19:03:46,000+0000" },

    { @"2011-02-07T19:03,123+09:00",       @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123+0900",        @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123+09",          @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123",             @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T19:03,123+08:00",       @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T19:03,123+0800",        @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T19:03,123+08",          @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T19:03,123Z",            @"2011-02-07T19:03:07,380+0000" },

    { @"2011-02-07T1903,123+09:00",        @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123+0900",         @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123+09",           @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123",              @"2011-02-07T10:03:07,380+0000" },
    { @"2011-02-07T1903,123+08:00",        @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T1903,123+0800",         @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T1903,123+08",           @"2011-02-07T11:03:07,380+0000" },
    { @"2011-02-07T1903,123Z",             @"2011-02-07T19:03:07,380+0000" },

    { @"2011-02-07T19,123+09:00",          @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123+0900",           @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123+09",             @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123",                @"2011-02-07T10:07:22,800+0000" },
    { @"2011-02-07T19,123+08:00",          @"2011-02-07T11:07:22,800+0000" },
    { @"2011-02-07T19,123+0800",           @"2011-02-07T11:07:22,800+0000" },
    { @"2011-02-07T19,123+08",             @"2011-02-07T11:07:22,800+0000" },
    { @"2011-02-07T19,123Z",               @"2011-02-07T19:07:22,800+0000" },

    { @"2011-02-07T19+09:00",              @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19+0900",               @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19+09",                 @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19",                    @"2011-02-07T10:00:00,000+0000" },
    { @"2011-02-07T19+08:00",              @"2011-02-07T11:00:00,000+0000" },
    { @"2011-02-07T19+0800",               @"2011-02-07T11:00:00,000+0000" },
    { @"2011-02-07T19+08",                 @"2011-02-07T11:00:00,000+0000" },
    { @"2011-02-07T19Z",                   @"2011-02-07T19:00:00,000+0000" },

    { @"20110207T19:03:46,123456+09:00",   @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456+0900",    @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456+09",      @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456",         @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123456+08:00",   @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123456+0800",    @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123456+08",      @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123456Z",        @"2011-02-07T19:03:46,123+0000" },

    { @"20110207T19:03:46,123+09:00",      @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123+0900",       @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123+09",         @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123",            @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T19:03:46,123+08:00",      @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123+0800",       @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123+08",         @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T19:03:46,123Z",           @"2011-02-07T19:03:46,123+0000" },

    { @"20110207T190346,123+09:00",        @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123+0900",         @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123+09",           @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123",              @"2011-02-07T10:03:46,123+0000" },
    { @"20110207T190346,123+08:00",        @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T190346,123+0800",         @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T190346,123+08",           @"2011-02-07T11:03:46,123+0000" },
    { @"20110207T190346,123Z",             @"2011-02-07T19:03:46,123+0000" },

    { @"20110207T19:03:46+09:00",          @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46+0900",           @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46+09",             @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46",                @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T19:03:46+08:00",          @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T19:03:46+0800",           @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T19:03:46+08",             @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T19:03:46Z",               @"2011-02-07T19:03:46,000+0000" },

    { @"20110207T190346+09:00",            @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346+0900",             @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346+09",               @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346",                  @"2011-02-07T10:03:46,000+0000" },
    { @"20110207T190346+08:00",            @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T190346+0800",             @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T190346+08",               @"2011-02-07T11:03:46,000+0000" },
    { @"20110207T190346Z",                 @"2011-02-07T19:03:46,000+0000" },

    { @"20110207T19:03,123+09:00",         @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123+0900",          @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123+09",            @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123",               @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T19:03,123+08:00",         @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T19:03,123+0800",          @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T19:03,123+08",            @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T19:03,123Z",              @"2011-02-07T19:03:07,380+0000" },

    { @"20110207T1903,123+09:00",          @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123+0900",           @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123+09",             @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123",                @"2011-02-07T10:03:07,380+0000" },
    { @"20110207T1903,123+08:00",          @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T1903,123+0800",           @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T1903,123+08",             @"2011-02-07T11:03:07,380+0000" },
    { @"20110207T1903,123Z",               @"2011-02-07T19:03:07,380+0000" },

    { @"20110207T19,123+09:00",            @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123+0900",             @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123+09",               @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123",                  @"2011-02-07T10:07:22,800+0000" },
    { @"20110207T19,123+08:00",            @"2011-02-07T11:07:22,800+0000" },
    { @"20110207T19,123+0800",             @"2011-02-07T11:07:22,800+0000" },
    { @"20110207T19,123+08",               @"2011-02-07T11:07:22,800+0000" },
    { @"20110207T19,123Z",                 @"2011-02-07T19:07:22,800+0000" },

    { @"20110207T19+09:00",                @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19+0900",                 @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19+09",                   @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19",                      @"2011-02-07T10:00:00,000+0000" },
    { @"20110207T19+08:00",                @"2011-02-07T11:00:00,000+0000" },
    { @"20110207T19+0800",                 @"2011-02-07T11:00:00,000+0000" },
    { @"20110207T19+08",                   @"2011-02-07T11:00:00,000+0000" },
    { @"20110207T19Z",                     @"2011-02-07T19:00:00,000+0000" },

    { @"2011-02T19:03:46,123456+09:00",    @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+0900",     @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+09",       @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456",          @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+08:00",    @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+0800",     @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123456+08",       @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123456Z",         @"2011-02-01T19:03:46,123+0000" },

    { @"2011-02T19:03:46,123+09:00",       @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123+0900",        @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123+09",          @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123",             @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T19:03:46,123+08:00",       @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123+0800",        @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123+08",          @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T19:03:46,123Z",            @"2011-02-01T19:03:46,123+0000" },

    { @"2011-02T190346,123+09:00",         @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123+0900",          @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123+09",            @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123",               @"2011-02-01T10:03:46,123+0000" },
    { @"2011-02T190346,123+08:00",         @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T190346,123+0800",          @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T190346,123+08",            @"2011-02-01T11:03:46,123+0000" },
    { @"2011-02T190346,123Z",              @"2011-02-01T19:03:46,123+0000" },

    { @"2011-02T19:03:46+09:00",           @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46+0900",            @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46+09",              @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46",                 @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T19:03:46+08:00",           @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T19:03:46+0800",            @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T19:03:46+08",              @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T19:03:46Z",                @"2011-02-01T19:03:46,000+0000" },

    { @"2011-02T190346+09:00",             @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346+0900",              @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346+09",                @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346",                   @"2011-02-01T10:03:46,000+0000" },
    { @"2011-02T190346+08:00",             @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T190346+0800",              @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T190346+08",                @"2011-02-01T11:03:46,000+0000" },
    { @"2011-02T190346Z",                  @"2011-02-01T19:03:46,000+0000" },

    { @"2011-02T19:03,123+09:00",          @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123+0900",           @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123+09",             @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123",                @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T19:03,123+08:00",          @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T19:03,123+0800",           @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T19:03,123+08",             @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T19:03,123Z",               @"2011-02-01T19:03:07,380+0000" },

    { @"2011-02T1903,123+09:00",           @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123+0900",            @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123+09",              @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123",                 @"2011-02-01T10:03:07,380+0000" },
    { @"2011-02T1903,123+08:00",           @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T1903,123+0800",            @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T1903,123+08",              @"2011-02-01T11:03:07,380+0000" },
    { @"2011-02T1903,123Z",                @"2011-02-01T19:03:07,380+0000" },

    { @"2011-02T19,123+09:00",             @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123+0900",              @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123+09",                @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123",                   @"2011-02-01T10:07:22,800+0000" },
    { @"2011-02T19,123+08:00",             @"2011-02-01T11:07:22,800+0000" },
    { @"2011-02T19,123+0800",              @"2011-02-01T11:07:22,800+0000" },
    { @"2011-02T19,123+08",                @"2011-02-01T11:07:22,800+0000" },
    { @"2011-02T19,123Z",                  @"2011-02-01T19:07:22,800+0000" },

    { @"2011-02T19+09:00",                 @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19+0900",                  @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19+09",                    @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19",                       @"2011-02-01T10:00:00,000+0000" },
    { @"2011-02T19+08:00",                 @"2011-02-01T11:00:00,000+0000" },
    { @"2011-02T19+0800",                  @"2011-02-01T11:00:00,000+0000" },
    { @"2011-02T19+08",                    @"2011-02-01T11:00:00,000+0000" },
    { @"2011-02T19Z",                      @"2011-02-01T19:00:00,000+0000" },

    { @"2011T19:03:46,123456+09:00",       @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456+0900",        @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456+09",          @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456",             @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123456+08:00",       @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123456+0800",        @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123456+08",          @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123456Z",            @"2011-01-01T19:03:46,123+0000" },

    { @"2011T19:03:46,123+09:00",          @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123+0900",           @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123+09",             @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123",                @"2011-01-01T10:03:46,123+0000" },
    { @"2011T19:03:46,123+08:00",          @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123+0800",           @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123+08",             @"2011-01-01T11:03:46,123+0000" },
    { @"2011T19:03:46,123Z",               @"2011-01-01T19:03:46,123+0000" },

    { @"2011T190346,123+09:00",            @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123+0900",             @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123+09",               @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123",                  @"2011-01-01T10:03:46,123+0000" },
    { @"2011T190346,123+08:00",            @"2011-01-01T11:03:46,123+0000" },
    { @"2011T190346,123+0800",             @"2011-01-01T11:03:46,123+0000" },
    { @"2011T190346,123+08",               @"2011-01-01T11:03:46,123+0000" },
    { @"2011T190346,123Z",                 @"2011-01-01T19:03:46,123+0000" },

    { @"2011T19:03:46+09:00",              @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46+0900",               @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46+09",                 @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46",                    @"2011-01-01T10:03:46,000+0000" },
    { @"2011T19:03:46+08:00",              @"2011-01-01T11:03:46,000+0000" },
    { @"2011T19:03:46+0800",               @"2011-01-01T11:03:46,000+0000" },
    { @"2011T19:03:46+08",                 @"2011-01-01T11:03:46,000+0000" },
    { @"2011T19:03:46Z",                   @"2011-01-01T19:03:46,000+0000" },

    { @"2011T190346+09:00",                @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346+0900",                 @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346+09",                   @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346",                      @"2011-01-01T10:03:46,000+0000" },
    { @"2011T190346+08:00",                @"2011-01-01T11:03:46,000+0000" },
    { @"2011T190346+0800",                 @"2011-01-01T11:03:46,000+0000" },
    { @"2011T190346+08",                   @"2011-01-01T11:03:46,000+0000" },
    { @"2011T190346Z",                     @"2011-01-01T19:03:46,000+0000" },

    { @"2011T19:03,123+09:00",             @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123+0900",              @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123+09",                @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123",                   @"2011-01-01T10:03:07,380+0000" },
    { @"2011T19:03,123+08:00",             @"2011-01-01T11:03:07,380+0000" },
    { @"2011T19:03,123+0800",              @"2011-01-01T11:03:07,380+0000" },
    { @"2011T19:03,123+08",                @"2011-01-01T11:03:07,380+0000" },
    { @"2011T19:03,123Z",                  @"2011-01-01T19:03:07,380+0000" },

    { @"2011T1903,123+09:00",              @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123+0900",               @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123+09",                 @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123",                    @"2011-01-01T10:03:07,380+0000" },
    { @"2011T1903,123+08:00",              @"2011-01-01T11:03:07,380+0000" },
    { @"2011T1903,123+0800",               @"2011-01-01T11:03:07,380+0000" },
    { @"2011T1903,123+08",                 @"2011-01-01T11:03:07,380+0000" },
    { @"2011T1903,123Z",                   @"2011-01-01T19:03:07,380+0000" },

    { @"2011T19,123+09:00",                @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123+0900",                 @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123+09",                   @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123",                      @"2011-01-01T10:07:22,800+0000" },
    { @"2011T19,123+08:00",                @"2011-01-01T11:07:22,800+0000" },
    { @"2011T19,123+0800",                 @"2011-01-01T11:07:22,800+0000" },
    { @"2011T19,123+08",                   @"2011-01-01T11:07:22,800+0000" },
    { @"2011T19,123Z",                     @"2011-01-01T19:07:22,800+0000" },

    { @"2011T19+09:00",                    @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19+0900",                     @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19+09",                       @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19",                          @"2011-01-01T10:00:00,000+0000" },
    { @"2011T19+08:00",                    @"2011-01-01T11:00:00,000+0000" },
    { @"2011T19+0800",                     @"2011-01-01T11:00:00,000+0000" },
    { @"2011T19+08",                       @"2011-01-01T11:00:00,000+0000" },
    { @"2011T19Z",                         @"2011-01-01T19:00:00,000+0000" },

    { @"2011-02-07",                       @"2011-02-06T15:00:00,000+0000" },
    { @"20110207",                         @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02",                          @"2011-01-31T15:00:00,000+0000" },
    { @"2011",                             @"2010-12-31T15:00:00,000+0000" },

    { @"2011-02-07T00:00:00+09:00",        @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00+0900",         @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00+09",           @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00",              @"2011-02-06T15:00:00,000+0000" },
    { @"2011-02-07T00:00:00+08:00",        @"2011-02-06T16:00:00,000+0000" },
    { @"2011-02-07T00:00:00+0800",         @"2011-02-06T16:00:00,000+0000" },
    { @"2011-02-07T00:00:00+08",           @"2011-02-06T16:00:00,000+0000" },
    { @"2011-02-07T00:00:00Z",             @"2011-02-07T00:00:00,000+0000" },

    { @"2011-02-07T24:00:00+09:00",        @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00+0900",         @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00+09",           @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00",              @"2011-02-07T15:00:00,000+0000" },
    { @"2011-02-07T24:00:00+08:00",        @"2011-02-07T16:00:00,000+0000" },
    { @"2011-02-07T24:00:00+0800",         @"2011-02-07T16:00:00,000+0000" },
    { @"2011-02-07T24:00:00+08",           @"2011-02-07T16:00:00,000+0000" },
    { @"2011-02-07T24:00:00Z",             @"2011-02-08T00:00:00,000+0000" },

    { nil,                                 nil                             }
};


static NSDateFormatter *gDefaultDateFormatter = nil;


@implementation NJISO8601Tests


+ (void)initialize
{
    if (!gDefaultDateFormatter)
    {
        gDefaultDateFormatter = [[NSDateFormatter alloc] init];
        [gDefaultDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss,SSSZZZ"];
        [gDefaultDateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
        [gDefaultDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
}


- (void)testDateFromString
{
    NJISO8601Formatter *sFormatter = [[[NJISO8601Formatter alloc] init] autorelease];
    NSDate             *sDate;
    CFAbsoluteTime      sTime;

    sTime = CFAbsoluteTimeGetCurrent();

    for (int i = 0; gTestStrings[i][0]; i++)
    {
        sDate = [sFormatter dateFromString:gTestStrings[i][0]];
        STAssertTrue([gTestStrings[i][1] isEqualToString:[gDefaultDateFormatter stringFromDate:sDate]], @"%@ == %@ => %@", gTestStrings[i][0], gTestStrings[i][1], [gDefaultDateFormatter stringFromDate:sDate]);
    }

    NSLog(@"NJISO8601Formatter Total Parse Time: %f", (CFAbsoluteTimeGetCurrent() - sTime));
}


- (void)testDateExpandedRepresentation
{
    NJISO8601Formatter *sFormatter = [[[NJISO8601Formatter alloc] init] autorelease];
    NSDate             *sDate;
    NSString           *sString;

    sDate = [sFormatter dateFromString:@"+12345-06-17T12:34:56,789+01:00"];
    STAssertNotNil(sDate, @"");
    sString = [sFormatter stringFromDate:sDate];
    STAssertTrue([sString isEqualToString:@"+12345-06-17T11:34:57Z"], @"%@", sString);

    sDate = [sFormatter dateFromString:@"+123450617T12:34:56,789+01:00"];
    STAssertNotNil(sDate, @"");
    sString = [sFormatter stringFromDate:sDate];
    STAssertTrue([sString isEqualToString:@"+12345-06-17T11:34:57Z"], @"%@", sString);

    sDate = [sFormatter dateFromString:@"+12345-06T12:34:56,789+01:00"];
    STAssertNotNil(sDate, @"");
    sString = [sFormatter stringFromDate:sDate];
    STAssertTrue([sString isEqualToString:@"+12345-06-01T11:34:57Z"], @"%@", sString);

    sDate = [sFormatter dateFromString:@"+12345T12:34:56,789+01:00"];
    STAssertNotNil(sDate, @"");
    sString = [sFormatter stringFromDate:sDate];
    STAssertTrue([sString isEqualToString:@"+12345-01-01T11:34:57Z"], @"%@", sString);

    sDate = [sFormatter dateFromString:@"+12345-001T12:34:56,789+01:00"];
    STAssertNotNil(sDate, @"");
    sString = [sFormatter stringFromDate:sDate];
    STAssertTrue([sString isEqualToString:@"+12345-01-01T11:34:57Z"], @"%@", sString);

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleCalendarBasic];
    sString = [sFormatter stringFromDate:sDate];
    STAssertTrue([sString isEqualToString:@"+123450101T11:34:57Z"], @"%@", sString);

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleOrdinalBasic];
    STAssertNil([sFormatter stringFromDate:sDate], @"Basic Format Not Allowed");

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleWeekBasic];
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"+12344-001T12:34:56,789+01:00"]];
    STAssertTrue([sString isEqualToString:@"+12343W526T11:34:57Z"], @"%@", sString);
}


- (void)testError
{
    NSString *sErrorStrings[] = {
        @"2011-02-07T24:01:01Z",
        @"2011-02-07T19:03:60Z",
        @"2011-02-07T19:60:46Z",
        @"2011-02-07T24:03:46Z",
        @"2011-02-00T19:03:46Z",
        @"2011-02-32T19:03:46Z",
        @"2011-13-07T19:03:46Z",
        @"2011-00-07T19:03:46Z",
        @"2011-02-07T19:03:46KST",
        @"2011-02-07T19:03:6Z",
        @"2011-02-07T19:03:6",
        @"2011-02-07T19:1",
        @"2011-02-07T1",
        @"2011-02-07T",
        @"2011-02-1T",
        @"2011-02-1",
        @"2011-0T",
        @"2011-0",
        @"201",
        @"MERONG",
        @"2011-00",
        @"2011-366T",
        @"2011-000",
        @"2011000T",
        @"2011366",
        @"+2011001T",
        nil
    };

    NSString *sUnsupportedStrings[] = {
        @"2011-12-30/",
        @"2011-12-30T12:34/",
        @"P",
        @"R",
        nil,
    };

    NJISO8601Formatter *sFormatter = [[[NJISO8601Formatter alloc] init] autorelease];
    NSString           *sError;
    id                  sObject;


    for (int i = 0; sErrorStrings[i]; i++)
    {
        NSString *sError = nil;
        id        sObject;

        STAssertNil([sFormatter dateFromString:sErrorStrings[i]], @"%@ => nil", sErrorStrings[i]);
        STAssertFalse([sFormatter getObjectValue:NULL forString:sErrorStrings[i] errorDescription:NULL], @"%@ => NO", sErrorStrings[i]);
        STAssertFalse([sFormatter getObjectValue:&sObject forString:sErrorStrings[i] errorDescription:NULL], @"%@ => NO", sErrorStrings[i]);
        STAssertFalse([sFormatter getObjectValue:&sObject forString:sErrorStrings[i] errorDescription:&sError], @"%@ => NO", sErrorStrings[i]);
        STAssertNotNil(sError, @"");
    }

    for (int i = 0; sUnsupportedStrings[i]; i++)
    {
        sError = nil;

        STAssertNil([sFormatter dateFromString:sUnsupportedStrings[i]], @"%@ => nil", sUnsupportedStrings[i]);
        STAssertFalse([sFormatter getObjectValue:NULL forString:sUnsupportedStrings[i] errorDescription:NULL], @"%@ => NO", sUnsupportedStrings[i]);
        STAssertFalse([sFormatter getObjectValue:&sObject forString:sUnsupportedStrings[i] errorDescription:NULL], @"%@ => NO", sUnsupportedStrings[i]);
        STAssertFalse([sFormatter getObjectValue:&sObject forString:sUnsupportedStrings[i] errorDescription:&sError], @"%@ => NO", sUnsupportedStrings[i]);
        STAssertNotNil(sError, @"");
        STAssertTrue([sError rangeOfString:@"not supported"].location != NSNotFound, @"%@ => %@", sUnsupportedStrings[i], sError);
    }

    sError = nil;

    STAssertNil([sFormatter dateFromString:nil], @"");
    STAssertFalse([sFormatter getObjectValue:NULL forString:nil errorDescription:NULL], @"");
    STAssertFalse([sFormatter getObjectValue:NULL forString:nil errorDescription:&sError], @"");
    STAssertNotNil(sError, @"");
}


- (void)testStringFromDate
{
    NJISO8601Formatter *sFormatter = [[[NJISO8601Formatter alloc] init] autorelease];
    NSDate             *sDate      = [sFormatter dateFromString:@"2011-02-07T19:03:46,123456+09:00"];
    NSString           *sString;

    if (sDate)
    {
        STAssertNil([sFormatter stringFromDate:nil], @"");
        STAssertNil([sFormatter stringForObjectValue:nil], @"");

        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([sString isEqualToString:@"2011-02-07T10:03:46Z"], @"%@", sString);

        sString = [sFormatter stringForObjectValue:sDate];
        STAssertTrue([sString isEqualToString:@"2011-02-07T10:03:46Z"], @"%@", sString);

        [sFormatter setTimeZoneStyle:NJISO8601FormatterTimeZoneStyleExtended];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T19:03:46+09:00"], @"%@", sString);

        [sFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-32400]];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T01:03:46-09:00"], @"%@", sString);

        [sFormatter setTimeZone:nil];
        [sFormatter setTimeZoneStyle:NJISO8601FormatterTimeZoneStyleBasic];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T19:03:46+0900"], @"%@", sString);

        [sFormatter setTimeZoneStyle:NJISO8601FormatterTimeZoneStyleNone];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T19:03:46"], @"%@", sString);

        [sFormatter setFractionDigits:6];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T19:03:46,123456"], @"%@", sString);

        [sFormatter setFractionDigits:4];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T19:03:46,1235"], @"%@", sString);

        [sFormatter setFractionSeparator:NJISO8601FormatterFractionSeparatorDot];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T19:03:46.1235"], @"%@", sString);

        [sFormatter setTimeStyle:NJISO8601FormatterTimeStyleBasic];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07T190346.1235"], @"%@", sString);

        [sFormatter setTimeStyle:NJISO8601FormatterTimeStyleNone];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"2011-02-07"], @"%@", sString);

        [sFormatter setDateStyle:NJISO8601FormatterDateStyleCalendarBasic];
        sString = [sFormatter stringFromDate:sDate];
        STAssertTrue([[sFormatter stringFromDate:sDate] isEqualToString:@"20110207"], @"%@", sString);
    }
    else
    {
        STFail(@"cannot create NSDate");
    }
}


- (void)testOrdinalDate
{
    NJISO8601Formatter *sFormatter = [[[NJISO8601Formatter alloc] init] autorelease];
    NSString           *sString;

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleOrdinalExtended];

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2000-03-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2000-061T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2000-061T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2000-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2000-366T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2000-366T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011-001T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011-001T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-03-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011-060T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011-060T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011-365T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011-365T00:00:00Z"], @"%@", sString);

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleOrdinalBasic];

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2000-03-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2000061T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2000061T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2000-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2000366T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2000366T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011001T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011001T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-03-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011060T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011060T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011365T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011365T00:00:00Z"], @"%@", sString);
}


- (void)testWeekDate
{
    NJISO8601Formatter *sFormatter = [[[NJISO8601Formatter alloc] init] autorelease];
    NSString           *sString;

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleWeekExtended];

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2000-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2000-W52-7T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2000-W52-7T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2002-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2002-W01-2T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2002-W01-2T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2008-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2009-W01-3T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2009-W01-3T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2010-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2009-W53-5T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2009-W53-5T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2010-12-25T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2010-W51-6T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2010-W51-6T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2010-W52-6T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2010-W52-6T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-01-08T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011-W01-6T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011-W01-6T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011-W52-6T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011-W52-6T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2012-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011-W52-7T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011-W52-7T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2012-01-02T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2012-W01-1T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2012-W01-1T00:00:00Z"], @"%@", sString);

    [sFormatter setDateStyle:NJISO8601FormatterDateStyleWeekBasic];

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2000-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2000W527T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2000W527T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2002-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2002W012T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2002W012T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2008-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2009W013T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2009W013T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2010-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2009W535T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2009W535T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2010-12-25T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2010W516T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2010W516T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2010W526T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2010W526T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-01-08T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011W016T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011W016T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2011-12-31T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011W526T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011W526T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2012-01-01T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2011W527T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2011W527T00:00:00Z"], @"%@", sString);

    sString = [sFormatter stringFromDate:[sFormatter dateFromString:@"2012-01-02T00:00:00Z"]];
    STAssertTrue([sString isEqualToString:@"2012W011T00:00:00Z"], @"%@", sString);
    sString = [sFormatter stringFromDate:[sFormatter dateFromString:sString]];
    STAssertTrue([sString isEqualToString:@"2012W011T00:00:00Z"], @"%@", sString);
}


- (void)testNSDateFormatter
{
    NSDateFormatter *sFormatter = [[[NSDateFormatter alloc] init] autorelease];
    NSDate          *sDate;
    CFAbsoluteTime   sTime;

    [sFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [sFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];

    sTime = CFAbsoluteTimeGetCurrent();

    for (int i = 0; gTestStrings[i][0]; i++)
    {
        sDate = [sFormatter dateFromString:gTestStrings[i][0]];
    }

    NSLog(@"NSDateFormatter Total Parse Time: %f", (CFAbsoluteTimeGetCurrent() - sTime));
}


- (void)testISO8601DateFormatter
{
    ISO8601DateFormatter *sFormatter = [[[ISO8601DateFormatter alloc] init] autorelease];
    NSDate               *sDate;
    CFAbsoluteTime        sTime;

    sTime = CFAbsoluteTimeGetCurrent();

    for (int i = 0; gTestStrings[i][0]; i++)
    {
        sDate = [sFormatter dateFromString:gTestStrings[i][0]];
    }

    NSLog(@"ISO8601DateFormatter Total Parse Time: %f", (CFAbsoluteTimeGetCurrent() - sTime));
}


@end

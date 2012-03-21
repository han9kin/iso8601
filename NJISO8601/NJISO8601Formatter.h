/*
 *  NJISO8601Formatter.h
 *  NJISO8601
 *
 *  Created by han9kin on 2012-03-21.
 *  Copyright (c) 2012 NHN. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


NSDate *NJISO8601DateFromString(NSString *aString);


@interface NJISO8601Formatter : NSFormatter


- (NSDate *)dateFromString:(NSString *)aString;


@end

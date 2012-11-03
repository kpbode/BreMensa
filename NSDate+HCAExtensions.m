//
//  NSDate+HCAExtensions.m
//  Mix
//
//  Created by Karl Bode on 25.06.12.
//  Copyright (c) 2012 hot coffee apps - Karl Bode und Jonas Panten GbR. All rights reserved.
//

#import "NSDate+HCAExtensions.h"

@implementation NSDate (HCAExtensions)

- (BOOL)HCA_isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
    NSDateComponents *selfComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return nowComponents.year == selfComponents.year && nowComponents.month == selfComponents.month && nowComponents.day == selfComponents.day;
}

@end

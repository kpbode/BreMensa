#import "NSDate+KPBAdditions.h"

@implementation NSDate (KPBAdditions)

- (BOOL)KPB_isTodayInCalendar:(NSCalendar *)calendar
{
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:now];
    NSDateComponents *selfComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return nowComponents.year == selfComponents.year && nowComponents.month == selfComponents.month && nowComponents.day == selfComponents.day;
}

@end

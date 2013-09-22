#import "NSCalendar+KPBAdditions.h"

@implementation NSCalendar (KPBAdditions)

+ (instancetype)KPB_germanCalendar
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    return calendar;
}

- (NSInteger)KPB_currentYear
{
    
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [self components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit fromDate:now];
    
    NSInteger currentYear = nowComponents.year;
    
    return currentYear;
}

- (NSInteger)KPB_currentWeek
{
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [self components:NSWeekOfYearCalendarUnit fromDate:now];
    
    NSInteger currentWeek = nowComponents.weekOfYear;
    
    return currentWeek;
}

@end

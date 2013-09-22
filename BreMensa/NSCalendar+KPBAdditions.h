#import <Foundation/Foundation.h>

@interface NSCalendar (KPBAdditions)

+ (instancetype)KPB_germanCalendar;

- (NSInteger)KPB_currentWeek;
- (NSInteger)KPB_currentYear;

@end

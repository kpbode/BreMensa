#import "KPBMealplan.h"
#import "KPBMenu.h"
#import "KPBMeal.h"

@implementation KPBMealplan

static NSString * const KPBMealplanWeekNumberKey = @"weeknumber";
static NSString * const KPBMealplanMenusKey = @"menus";
static NSString * const KPBMealplanFetchDateKey = @"fetchDate";

+ (instancetype)mealplanFromDictionary:(NSDictionary *)dictionary
{
    NSCalendar *calendar = [NSCalendar KPB_germanCalendar];
    
    NSInteger currentWeek = [calendar KPB_currentWeek];
    NSInteger currentYear = [calendar KPB_currentYear];
    
    NSInteger weekNumber = [dictionary[@"weeknumber"] integerValue];
    NSArray *menuDictionaries = dictionary[@"menues"];
    
    if (weekNumber != currentWeek) {
        NSLog(@"weeks do not match: %li != %li", (long) weekNumber, (long) currentWeek);
    }
    
    NSMutableArray *menus = [[NSMutableArray alloc] init];
    
    for (NSDictionary *menuDictionary in menuDictionaries) {
        
        NSInteger day = [menuDictionary[@"day"] integerValue];
        NSArray *foodDictionaries = menuDictionary[@"foods"];
        NSInteger serverId = [menuDictionary[@"id"] integerValue];
        
        NSDateComponents *menuDateComponents = [[NSDateComponents alloc] init];
        menuDateComponents.weekOfYear = currentWeek;
        menuDateComponents.year = currentYear;
        menuDateComponents.weekday = day + 2;
        
        KPBMenu *menu = [[KPBMenu alloc] init];
        menu.date = [calendar dateFromComponents:menuDateComponents];
        menu.serverId = serverId;
        
        NSMutableArray *meals = [[NSMutableArray alloc] init];
        
        for (NSDictionary *foodDictionary in foodDictionaries) {
            
            KPBMeal *meal = [KPBMeal mealFromDictionary:foodDictionary];
            if (meal != nil) {
                
            }
            
            [meals addObject:meal];
        }
        
        menu.meals = meals;
        
        [menus addObject:menu];
    }
    
    KPBMealplan *mealplan = [[KPBMealplan alloc] init];
    mealplan.menus = menus;
    mealplan.fetchDate = [NSDate date];
    mealplan.weekNumber = weekNumber;
    
    return mealplan;
}

- (BOOL)isValid
{
    if ([_menus count] != 5) return NO;
    if (_weekNumber == 0) return NO;
    return YES;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.weekNumber = [decoder decodeIntegerForKey:KPBMealplanWeekNumberKey];
        self.menus = [decoder decodeObjectForKey:KPBMealplanMenusKey];
        self.fetchDate = [decoder decodeObjectForKey:KPBMealplanFetchDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.weekNumber forKey:KPBMealplanWeekNumberKey];
    [coder encodeObject:self.menus forKey:KPBMealplanMenusKey];
    [coder encodeObject:self.fetchDate forKey:KPBMealplanFetchDateKey];
}

@end

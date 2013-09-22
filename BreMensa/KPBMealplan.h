#import <Foundation/Foundation.h>

@class KPBMensa;

@interface KPBMealplan : NSObject <NSCoding>

+ (instancetype)mealplanFromDictionary:(NSDictionary *)dictionary;

@property (nonatomic, weak) KPBMensa *mensa;
@property (nonatomic) NSInteger weekNumber;
@property (nonatomic, copy) NSArray *menus;
@property (nonatomic) NSDate *fetchDate;

@end

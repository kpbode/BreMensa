#import "KPBAppConfig.h"

@implementation KPBAppConfig

static NSString * const KPBAppConfigShowMealsAtFullWidth = @"show_meals_at_full_width";

+ (void)prepareDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:KPBAppConfigShowMealsAtFullWidth] == nil) {
        [userDefaults setBool:NO forKey:KPBAppConfigShowMealsAtFullWidth];
    }
    [userDefaults synchronize];
}

+ (BOOL)isShowMealsAtFullWidthEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:KPBAppConfigShowMealsAtFullWidth];
}

@end

#import "KPBAppConfig.h"

@implementation KPBAppConfig

static NSString * const KPBAppConfigShowMealsAtFullWidth = @"show_meals_at_full_width";

+ (NSDictionary *)apiKeys
{
    static NSDictionary *apiKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"apiKeys.plist" ofType:nil];
        apiKeys = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    });
    return apiKeys;
}

+ (NSString *)hockeyAppApiKey
{
    return [[self class] apiKeys][@"HockeyApp"];
}

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

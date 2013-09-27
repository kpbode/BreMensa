#import <Foundation/Foundation.h>

@interface KPBAppConfig : NSObject

+ (NSString *)hockeyAppApiKey;

+ (void)prepareDefaults;
+ (BOOL)isShowMealsAtFullWidthEnabled;

@end

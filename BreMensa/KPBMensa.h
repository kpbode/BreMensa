#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class KPBMealplan;

@interface KPBMensa : NSObject

+ (NSArray *)availableMensaObjects;
+ (NSString *)backendBasePath;
+ (BOOL)isBackendReachable;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *serverId;
@property (nonatomic, copy) NSArray *openingInfos;
@property (nonatomic) CLLocation *location;

- (BOOL)isCurrentMealplanCached;
- (KPBMealplan *)cachedMealplan;
- (void)currentMealplanWithSuccess:(void (^)(KPBMensa *mensa, KPBMealplan *mealplan))success failure:(void (^)(KPBMensa *mensa, NSError *error))failure;

@end

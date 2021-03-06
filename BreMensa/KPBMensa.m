#import "KPBMensa.h"
#import "KPBMealplan.h"
#import "KPBMensaOpeningInfo.h"
#import <Reachability/Reachability.h>

@implementation KPBMensa

+ (void)initialize
{
    [[self class] reachability];
}

+ (Reachability *)reachability
{
    static Reachability *reachability;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reachability = [Reachability reachabilityWithHostname:@"appspot.com"];
    });
    return reachability;
}

+ (BOOL)isBackendReachable
{
    return [[[self class] reachability] isReachable];
}

+ (NSString *)backendBasePath
{
    return @"http://foodspl.appspot.com"; // should go to config
}

+ (NSArray *)availableMensaObjects
{
    static NSArray *mensas;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]];
        NSArray *mensaDictionaries = config[@"application_config"][@"mensa_config"];
        
        NSMutableArray *loadedMensas = [[NSMutableArray alloc] init];
        for (NSDictionary *mensaDictionary in mensaDictionaries) {
            KPBMensa *mensa = [KPBMensa mensaFromDictionary:mensaDictionary];
            if (mensa != nil) {
                [loadedMensas addObject:mensa];
            }
            
            
        }
        mensas = [loadedMensas copy];
    });
    return mensas;
}

+ (instancetype)mensaFromDictionary:(NSDictionary *)dictionary
{
    
    KPBMensa *mensa = [[KPBMensa alloc] init];
    mensa.name = dictionary[@"name"];
    mensa.serverId = dictionary[@"serverId"];
    
    double latitude = [dictionary[@"latitude"] doubleValue];
    double longitude = [dictionary[@"longitude"] doubleValue];
    
    mensa.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    NSMutableArray *openingInfos = [[NSMutableArray alloc] init];
    
    NSArray *openingInfoDictionaries = dictionary[@"openingInfos"];
    
    for (NSDictionary *openingInfoDictionary in openingInfoDictionaries) {
        
        KPBMensaOpeningInfo *openingInfo = [KPBMensaOpeningInfo openingInfoFromDictionary:openingInfoDictionary];
        if (openingInfo != nil) {
            [openingInfos addObject:openingInfo];
        }
    }
    
    mensa.openingInfos = openingInfos;
    return mensa;
}

- (void)currentMealplanWithSuccess:(void (^)(KPBMensa *mensa, KPBMealplan *mealplan))success
                           failure:(void (^)(KPBMensa *mensa, NSError *error))failure
{
    if ([self isCurrentMealplanCached]) {
        KPBMealplan *mealplan = [self cachedMealplan];
        success(self, mealplan);
    } else {
        [self fetchMealplanWithSuccess:success failure:failure];
    }
}
        
- (KPBMealplan *)cachedMealplan
{
    NSString *filePath = [self currentMealplanFilePath];
    
    NSData *mealplanData = [[NSData alloc] initWithContentsOfFile:filePath];
    if (mealplanData == nil) return nil;
    
    KPBMealplan *mealplan = [NSKeyedUnarchiver unarchiveObjectWithData:mealplanData];
    mealplan.mensa = self;
    
    return mealplan;
}

- (BOOL)isCurrentMealplanCached
{
    KPBMealplan *mealplan = [self cachedMealplan];
    if (mealplan == nil) return NO;
    
    NSInteger currentWeek = [[NSCalendar KPB_germanCalendar] KPB_currentWeek];
    
    return currentWeek == mealplan.weekNumber;
}

- (NSString *)currentMealplanFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirPath = [paths objectAtIndex:0];
    
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", _serverId]];
    
    return filePath;
}

- (void)fetchMealplanWithSuccess:(void (^)(KPBMensa *mensa, KPBMealplan *mealplan))success
                         failure:(void (^)(KPBMensa *mensa, NSError *error))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/mensa?id=%@&format=json", [[self class] backendBasePath], _serverId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    static NSOperationQueue *operationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operationQueue = [[NSOperationQueue alloc] init];
    });
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(self, connectionError);
            });
            return;
        }
        
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode >= 400) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(self, connectionError);
            });
            return;
        }
        
        NSError *jsonError;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (responseObject == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(self, jsonError);
            });
            return;
        }
        
        KPBMealplan *mealplan = [KPBMealplan mealplanFromDictionary:responseObject];
        mealplan.mensa = self;
        
        NSData *mealplanData = [NSKeyedArchiver archivedDataWithRootObject:mealplan];
        NSString *mealplanFilePath = [self currentMealplanFilePath];
        
        if (![mealplanData writeToFile:mealplanFilePath atomically:NO]) {
            NSLog(@"failed to write mealplan to disk");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            success(self, mealplan);
        });
    }];
    
}

@end

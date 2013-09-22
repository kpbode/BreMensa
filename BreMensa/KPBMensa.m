#import "KPBMensa.h"
#import "KPBMealplan.h"
#import "KPBMensaOpeningInfo.h"
#import <AFNetworking/AFJSONRequestOperation.h>

@implementation KPBMensa

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
    
    NSInteger currentWeek = [[NSCalendar KPB_germanCalendar] KPB_currentWeek];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *filePath = [self currentMealplanFilePath];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        
        [self fetchMealplanWithSuccess:success failure:failure];
        
    } else {
        
        NSData *mealplanData = [[NSData alloc] initWithContentsOfFile:filePath];
        KPBMealplan *mealplan = [NSKeyedUnarchiver unarchiveObjectWithData:mealplanData];
        mealplan.mensa = self;
        
        if (currentWeek == mealplan.weekNumber) {
            success(self, mealplan);
        } else {
            
            NSError *removeError = nil;
            if (![fileManager removeItemAtPath:filePath error:&removeError]) {
                NSLog(@"failed to delete file at path: %@ (%@)", filePath, removeError);
            }
            
            [self fetchMealplanWithSuccess:success failure:failure];
        }
        
    }
    
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
    NSString *serverBasePath = @"http://17.foodspl.appspot.com"; // belongs in config
    NSString *urlString = [NSString stringWithFormat:@"%@/mensa?id=%@&format=json", serverBasePath, _serverId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFJSONRequestOperation *fetchRequestOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    // app engine server answers with text/html on initial request
    fetchRequestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[ @"text/html", @"application/json" ]];
    [fetchRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"response content type: %@", operation.response.allHeaderFields[@"Content-Type"]);
        
        KPBMealplan *mealplan = [KPBMealplan mealplanFromDictionary:responseObject];
        mealplan.mensa = self;
        
        NSData *mealplanData = [NSKeyedArchiver archivedDataWithRootObject:mealplan];
        NSString *mealplanFilePath = [self currentMealplanFilePath];
        
        if (![mealplanData writeToFile:mealplanFilePath atomically:NO]) {
            NSLog(@"failed to write mealplan to disk");
        }
        
        success(self, mealplan);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self, error);
        
    }];
    [fetchRequestOperation start];
}

@end

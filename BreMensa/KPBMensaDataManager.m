//
//  KPBMensaDataManager.m
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMensaDataManager.h"

@interface KPBMensaDataManager ()

@property (nonatomic, copy, readwrite) NSArray *mensas;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;

- (void)loadMealplanForMensa:(KPBMensa *)mensa withBlock:(KPBMensaDataManagerGetMealplanBlock)block;

- (NSString *)mealplanFilePathForMensa:(KPBMensa *)mensa;

@end

@implementation KPBMensaDataManager

+ (KPBMensaDataManager *)sharedManager
{
    static KPBMensaDataManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[KPBMensaDataManager alloc] init];
    });
    return sharedManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *config = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"]];
        NSArray *mensaConfigs = config[@"application_config"][@"mensa_config"];
        NSMutableArray *mensas = [[NSMutableArray alloc] init];
        for (NSDictionary *mensaConfig in mensaConfigs) {
            KPBMensa *mensa = [[KPBMensa alloc] init];
            mensa.name = mensaConfig[@"name"];
            mensa.serverId = mensaConfig[@"serverId"];
            
            double latitude = [mensaConfig[@"latitude"] doubleValue];
            double longitude = [mensaConfig[@"longitude"] doubleValue];
            
            mensa.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
            
                    
            NSMutableArray *openingInfos = [[NSMutableArray alloc] init];
            
            NSArray *openingInfoDictionaries = mensaConfig[@"openingInfos"];
            
            for (NSDictionary *openingInfoDictionary in openingInfoDictionaries) {
                
                KPBMensaOpeningInfo *openingInfo = [[KPBMensaOpeningInfo alloc] init];
                openingInfo.title = openingInfoDictionary[@"title"];
                openingInfo.subtitle = openingInfoDictionary[@"subtitle"];
                
                NSMutableArray *openingTimes = [[NSMutableArray alloc] init];
                
                NSArray *openingTimeDictionaries = openingInfoDictionary[@"times"];
                
                for (NSDictionary *openingTimeDictionary in openingTimeDictionaries) {
                    
                    KPBMensaOpeningTime *openingTime = [[KPBMensaOpeningTime alloc] init];
                    
                    openingTime.label = openingTimeDictionary[@"label"];
                    openingTime.value = openingTimeDictionary[@"value"];
                    
                    [openingTimes addObject:openingTime];
                }
                
                openingInfo.times = openingTimes;
                
                [openingInfos addObject:openingInfo];
            }
            
            mensa.openingInfos = openingInfos;
            
            
            [mensas addObject:mensa];
        }
        self.mensas = mensas;
    }
    return self;
}

- (BOOL)mealplanForMensa:(KPBMensa *)mensa withBlock:(KPBMensaDataManagerGetMealplanBlock)block
{
    if (mensa == nil) {
        NSLog(@"mensa must not be nil");
        return NO;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit fromDate:now];
    
    NSInteger currentWeek = nowComponents.weekOfYear;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString *filePath = [self mealplanFilePathForMensa:mensa];
        
//        if (![fileManager fileExistsAtPath:filePath]) {
        if (YES) {
            
            [self loadMealplanForMensa:mensa withBlock:block];
            
        } else {
            
            NSData *mealplanData = [[NSData alloc] initWithContentsOfFile:filePath];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:mealplanData];
            KPBMealplan *mealplan = [unarchiver decodeObject];
            [unarchiver finishDecoding];
            
            if (currentWeek == mealplan.weekNumber) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(mealplan);
                });
            } else {
                
                NSError *removeError = nil;
                if (![fileManager removeItemAtPath:filePath error:&removeError]) {
                    NSLog(@"failed to delete file at path: %@ (%@)", filePath, removeError);
                }
                
                [self loadMealplanForMensa:mensa withBlock:block];
            }
        
        }
        
    });
    
    return YES;
}

- (void)loadMealplanForMensa:(KPBMensa *)mensa withBlock:(KPBMensaDataManagerGetMealplanBlock)block
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComponents = [calendar components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit fromDate:now];
    
    NSInteger currentWeek = nowComponents.weekOfYear;
    NSInteger currentYear = nowComponents.year;
    
    NSString *serverBasePath = @"http://17.foodspl.appspot.com";
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mensa?id=%@&format=json", serverBasePath, mensa.serverId];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            NSLog(@"something went wrong when retrieving the data: %@", error);
            return dispatch_async(dispatch_get_main_queue(), ^{
                block(nil);
            });
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonObject == nil) {
            NSLog(@"failed to read json from server: %@", jsonError);
            return dispatch_async(dispatch_get_main_queue(), ^{
                block(nil);
            });
        }
        
        NSInteger weekNumber = [jsonObject[@"weeknumber"] integerValue];
        NSArray *menuDictionaries = jsonObject[@"menues"];
        
        if (weekNumber != currentWeek) {
            NSLog(@"weeks do not match: %i != %i", weekNumber, currentWeek);
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
                
                KPBMeal *meal = [[KPBMeal alloc] init];
                meal.title = foodDictionary[@"title"];
                meal.text = foodDictionary[@"desc"];
                meal.staffPrice = foodDictionary[@"staffprice"];
                meal.studentPrice = foodDictionary[@"studentprice"];
                meal.type = [foodDictionary[@"type"] integerValue];
                meal.extra = [foodDictionary[@"extra"] integerValue];
                meal.serverId = [foodDictionary[@"id"] integerValue];
                
                [meals addObject:meal];
            }
            
            menu.meals = meals;
            
            [menus addObject:menu];
        }
        
        KPBMealplan *mealplan = [[KPBMealplan alloc] init];
        mealplan.mensaId = mensa.serverId;
        mealplan.menus = menus;
        mealplan.fetchDate = [NSDate date];
        mealplan.weekNumber = weekNumber;
        
        NSMutableData *mealplanData = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mealplanData];
        [archiver encodeObject:mealplan];
        [archiver finishEncoding];
        
        NSString *filePath = [self mealplanFilePathForMensa:mensa];
        
        if (![mealplanData writeToFile:filePath atomically:YES]) {
            NSLog(@"failed to write mealplan to disk");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(mealplan);
        });
        
    }];
}

- (NSString *)mealplanFilePathForMensa:(KPBMensa *)mensa
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cacheDirPath = [paths objectAtIndex:0];
    
    NSString *filePath = [cacheDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.data", mensa.serverId]];
    
    return filePath;
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue != nil) return _operationQueue;
    
    _operationQueue = [[NSOperationQueue alloc] init];
    
    return _operationQueue;
}

@end

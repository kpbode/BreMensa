//
//  KPBNavigationManager.m
//  BreMensa
//
//  Created by Karl Bode on 03.12.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBNavigationManager.h"
#import "KPBPadNavigationManager.h"
#import "KPBPhoneNavigationManager.h"
#import "KPBMensa.h"
#import "KPBMensaDataManager.h"

NSString * KPBNavigationManagerLastViewedMensa = @"KPBNavigationManagerLastViewedMensa";

@implementation KPBNavigationManager

+ (KPBNavigationManager *)sharedManager
{
    static KPBNavigationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (IS_IPAD) {
            _sharedManager = [[KPBPadNavigationManager alloc] init];
        } else {
            _sharedManager = [[KPBPhoneNavigationManager alloc] init];
        }
    });
    return _sharedManager;
}

- (void)showMealplanForMensa:(KPBMensa *)mensa
{
    if (mensa == nil) return;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:mensa.serverId forKey:KPBNavigationManagerLastViewedMensa];
    [userDefaults synchronize];
}

- (void)showDetailsForMensa:(KPBMensa *)mensa
{
}

- (void)showMoreInfo
{
}

- (KPBMensa *)lastViewedMensa
{
    NSString *serverId = [[NSUserDefaults standardUserDefaults] objectForKey:KPBNavigationManagerLastViewedMensa];
    return [[KPBMensaDataManager sharedManager] mensaForServerId:serverId];
}

- (void)resetLastViewedMensa
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KPBNavigationManagerLastViewedMensa];
    [userDefaults synchronize];
}

@end

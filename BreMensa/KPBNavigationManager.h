//
//  KPBNavigationManager.h
//
//  Created by Karl Bode on 03.12.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KPBMensa;

extern const NSString * KPBNavigationManagerLastViewedMensa;

@interface KPBNavigationManager : NSObject

+ (KPBNavigationManager *)sharedManager;

@property (nonatomic, strong, readonly) UIViewController *rootViewController;

- (void)showMealplanForMensa:(KPBMensa *)mensa;

- (void)showDetailsForMensa:(KPBMensa *)mensa;

- (void)showMoreInfo;

- (KPBMensa *)lastViewedMensa;
- (void)resetLastViewedMensa;

@end

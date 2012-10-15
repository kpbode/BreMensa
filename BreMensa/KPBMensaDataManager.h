//
//  KPBMensaDataManager.h
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBMensa.h"
#import "KPBMealplan.h"

typedef void(^KPBMensaDataManagerGetMealplanBlock)(KPBMealplan *mealplan);

@interface KPBMensaDataManager : NSObject

+ (KPBMensaDataManager *)sharedManager;

@property (nonatomic, copy, readonly) NSArray *mensas;

- (BOOL)mealplanForMensa:(KPBMensa *)mensa withBlock:(KPBMensaDataManagerGetMealplanBlock)block;

@end

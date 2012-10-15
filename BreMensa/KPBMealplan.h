//
//  KPBMealplan.h
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBMenu.h"

@interface KPBMealplan : NSObject <NSCoding>

@property (nonatomic, copy, readwrite) NSString *mensaId;
@property (nonatomic, assign, readwrite) NSInteger weekNumber;
@property (nonatomic, copy, readwrite) NSArray *menus;
@property (nonatomic, copy, readwrite) NSDate *fetchDate;

@end

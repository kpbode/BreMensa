//
//  KPBMenu.h
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBMeal.h"

@interface KPBMenu : NSObject <NSCoding>

@property (nonatomic, strong, readwrite) NSDate *date;
@property (nonatomic, assign, readwrite) NSInteger serverId;
@property (nonatomic, copy, readwrite) NSArray *meals;

@end

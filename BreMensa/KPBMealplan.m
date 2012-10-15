//
//  KPBMealplan.m
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMealplan.h"

@implementation KPBMealplan

#define kMensaIdKey @"mensaId"
#define kWeekNumberKey @"weeknumber"
#define kMenusKey @"menus"
#define kFetchDateKey @"fetchDate"

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.mensaId = [decoder decodeObjectForKey:kMensaIdKey];
        self.weekNumber = [decoder decodeIntegerForKey:kWeekNumberKey];
        self.menus = [decoder decodeObjectForKey:kMenusKey];
        self.fetchDate = [decoder decodeObjectForKey:kFetchDateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.mensaId forKey:kMensaIdKey];
    [coder encodeInteger:self.weekNumber forKey:kWeekNumberKey];
    [coder encodeObject:self.menus forKey:kMenusKey];
    [coder encodeObject:self.fetchDate forKey:kFetchDateKey];
}

@end

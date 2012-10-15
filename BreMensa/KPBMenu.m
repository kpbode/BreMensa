//
//  KPBMenu.m
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMenu.h"

#define kDateKey @"date"
#define kServerIdKey @"serverId"
#define kMealsKey @"meals"

@implementation KPBMenu

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.date = [decoder decodeObjectForKey:kDateKey];
        self.serverId = [decoder decodeIntegerForKey:kServerIdKey];
        self.meals = [decoder decodeObjectForKey:kMealsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.date forKey:kDateKey];
    [coder encodeInteger:self.serverId forKey:kServerIdKey];
    [coder encodeObject:self.meals forKey:kMealsKey];
}

@end

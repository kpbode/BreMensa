//
//  KPBMensaLocationMarker.m
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMensaLocationMarker.h"

@interface KPBMensaLocationMarker ()

@property (nonatomic, strong, readwrite) KPBMensa *mensa;

@end

@implementation KPBMensaLocationMarker

- (id)initWithMensa:(KPBMensa *)mensa
{
    self = [super init];
    if (self) {
        self.mensa = mensa;
    }
    return self;
}

- (NSString *)title
{
    return self.mensa.name;
}

- (NSString *)subtitle
{
    return @"";
}

- (CLLocationCoordinate2D)coordinate
{
    return self.mensa.location.coordinate;
}

@end

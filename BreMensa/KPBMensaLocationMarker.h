//
//  KPBMensaLocationMarker.h
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "KPBMensa.h"

@interface KPBMensaLocationMarker : NSObject <MKAnnotation>

- (id)initWithMensa:(KPBMensa *)mensa;

@end

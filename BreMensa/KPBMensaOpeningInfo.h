//
//  KPBMensaOpeningInfo.h
//  BreMensa
//
//  Created by Karl Bode on 16.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBMensaOpeningTime.h"

@interface KPBMensaOpeningInfo : NSObject

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *subtitle;
@property (nonatomic, copy, readwrite) NSArray *times;

@end

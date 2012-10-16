//
//  KPBMensa.h
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KPBMensaOpeningInfo.h"

@interface KPBMensa : NSObject

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *serverId;
@property (nonatomic, copy, readwrite) NSArray *openingInfos;

@end

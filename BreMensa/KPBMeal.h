//
//  KPBMeal.h
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    KPBMealTypeVegetarian = 86,
    KPBMealTypeVegan = 80,
    KPBMealTypeVenison = 87,
    KPBMealTypePork = 83,
    KPBMealTypeFish = 70,
    KPBMealTypeBeef = 82,
    KPBMealTypeFowl = 71,
    KPBMealTypeLamb = 76,
    KPBMealTypeUndefined = 79
} KPBMealType;

typedef enum {
    KPBMealExtraDessert = 44,
    KPBMealExtraSoup = 84,
    KPBMealExtraNone = 78
} KPBMealExtra;

@interface KPBMeal : NSObject <NSCoding>

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, copy, readwrite) NSString *staffPrice;
@property (nonatomic, copy, readwrite) NSString *studentPrice;
@property (nonatomic, assign, readwrite) KPBMealType type;
@property (nonatomic, assign, readwrite) KPBMealExtra extra;
@property (nonatomic, assign, readwrite) NSInteger serverId;

- (NSString *)typeAsString;
- (NSString *)extraAsString;

- (NSString *)priceText;
- (NSString *)infoText;

@end

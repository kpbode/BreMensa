//
//  KPBMeal.m
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMeal.h"

#define kTitleKey @"title"
#define kTextKey @"text"
#define kStaffPriceKey @"staffPrice"
#define kStudentPriceKey @"studentPrice"
#define kTypeKey @"type"
#define kExtraKey @"extra"
#define kServerIdKey @"serverId"

@implementation KPBMeal

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:kTitleKey];
        self.text = [decoder decodeObjectForKey:kTextKey];
        self.staffPrice = [decoder decodeObjectForKey:kStaffPriceKey];
        self.studentPrice = [decoder decodeObjectForKey:kStudentPriceKey];
        self.extra = [decoder decodeIntegerForKey:kExtraKey];
        self.type = [decoder decodeIntegerForKey:kTypeKey];
        self.serverId = [decoder decodeIntegerForKey:kServerIdKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:kTitleKey];
    [coder encodeObject:self.text forKey:kTextKey];
    [coder encodeObject:self.staffPrice forKey:kStaffPriceKey];
    [coder encodeObject:self.studentPrice forKey:kStudentPriceKey];
    [coder encodeInteger:self.extra forKey:kExtraKey];
    [coder encodeInteger:self.type forKey:kTypeKey];
    [coder encodeInteger:self.serverId forKey:kServerIdKey];
}

- (NSString *)priceText
{
    NSString *text = nil;
    if (self.studentPrice != nil) {
        text = [NSString stringWithFormat:@"Studenten: %@", self.studentPrice];
    }
    
    if (self.staffPrice != nil) {
        if (text != nil) {
            text = [text stringByAppendingString:@" - "];
        } else {
            text = @"";
        }
        text = [text stringByAppendingFormat:@"Mitarbeiter: %@", self.staffPrice];
    }
    
    return text;
}

- (NSString *)infoText
{
    NSString *text = nil;
    if ([self typeAsString] != nil) {
        text = [self typeAsString];
    }
    
    if ([self extraAsString] != nil) {
        if (text == nil) {
            text = @"";
        } else {
            text = [text stringByAppendingString:@" | "];
        }
        
        text = [text stringByAppendingString:[self extraAsString]];
    }
    
    return text;
}

- (NSString *)typeAsString
{
    switch (self.type) {
        case KPBMealTypeVegetarian: return @"vegetarisch";
        case KPBMealTypeVegan: return @"vegan";
        case KPBMealTypeVenison: return @"Wild";
        case KPBMealTypePork: return @"Schwein";
        case KPBMealTypeFish: return @"Fisch";
        case KPBMealTypeBeef: return @"Rind";
        case KPBMealTypeFowl: return @"Geflügel";
        case KPBMealTypeLamb: return @"Lamm";
        case KPBMealTypeUndefined: return nil;
    }
    return nil;
}

- (NSString *)extraAsString
{
    switch (self.extra) {
        case KPBMealExtraDessert: return @"Dessert";
        case KPBMealExtraSoup: return @"Suppe";
        case KPBMealExtraNone: return nil;
    }
    return nil;
}

@end

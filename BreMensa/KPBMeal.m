#import "KPBMeal.h"

static NSString * const KPBMealTitleKey = @"title";
static NSString * const KPBMealTextKey = @"text";
static NSString * const KPBMealStaffPriceKey = @"staffPrice";
static NSString * const KPBMealStudentPriceKey = @"studentPrice";
static NSString * const KPBMealTypeKey = @"type";
static NSString * const KPBMealExtraKey = @"extra";
static NSString * const KPBServerIdKey = @"serverId";

@implementation KPBMeal

+ (instancetype)mealFromDictionary:(NSDictionary *)dictionary
{
    KPBMeal *meal = [[KPBMeal alloc] init];
    meal.title = dictionary[@"title"];
    meal.text = dictionary[@"desc"];
    meal.staffPrice = dictionary[@"staffprice"];
    meal.studentPrice = dictionary[@"studentprice"];
    meal.type = [dictionary[@"type"] integerValue];
    meal.extra = [dictionary[@"extra"] integerValue];
    meal.serverId = [dictionary[@"id"] integerValue];
    return meal;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.title = [decoder decodeObjectForKey:KPBMealTitleKey];
        self.text = [decoder decodeObjectForKey:KPBMealTextKey];
        self.staffPrice = [decoder decodeObjectForKey:KPBMealStaffPriceKey];
        self.studentPrice = [decoder decodeObjectForKey:KPBMealStudentPriceKey];
        self.extra = [decoder decodeIntegerForKey:KPBMealExtraKey];
        self.type = [decoder decodeIntegerForKey:KPBMealTypeKey];
        self.serverId = [decoder decodeIntegerForKey:KPBServerIdKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_title forKey:KPBMealTitleKey];
    [coder encodeObject:_text forKey:KPBMealTextKey];
    [coder encodeObject:_staffPrice forKey:KPBMealStaffPriceKey];
    [coder encodeObject:_studentPrice forKey:KPBMealStudentPriceKey];
    [coder encodeInteger:_extra forKey:KPBMealExtraKey];
    [coder encodeInteger:_type forKey:KPBMealTypeKey];
    [coder encodeInteger:_serverId forKey:KPBServerIdKey];
}

- (NSString *)priceText
{
    NSString *text = nil;
    if (self.studentPrice != nil) {
        text = [NSString stringWithFormat:@"Studenten: %@", self.studentPrice];
    }
    
    if (self.staffPrice != nil) {
        if (text != nil) {
            text = [text stringByAppendingString:@"\n"];
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
        case KPBMealTypeVegetarian: return NSLocalizedString(@"vegetarian", nil);
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

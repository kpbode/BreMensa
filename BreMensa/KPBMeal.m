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
        text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"students", nil), self.studentPrice];
    }
    
    if (self.staffPrice != nil) {
        if (text != nil) {
            text = [text stringByAppendingString:@"\n"];
        } else {
            text = @"";
        }
        text = [text stringByAppendingFormat:@"%@: %@", NSLocalizedString(@"staff", nil), self.staffPrice];
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
        case KPBMealTypeVegan: return NSLocalizedString(@"vegan", nil);
        case KPBMealTypeVenison: return NSLocalizedString(@"venison", nil);
        case KPBMealTypePork: return NSLocalizedString(@"pork", nil);
        case KPBMealTypeFish: return NSLocalizedString(@"fish", nil);
        case KPBMealTypeBeef: return NSLocalizedString(@"beef", nil);
        case KPBMealTypeFowl: return NSLocalizedString(@"fowl", nil);
        case KPBMealTypeLamb: return NSLocalizedString(@"lamb", nil);
        case KPBMealTypeUndefined: return nil;
    }
    return nil;
}

- (NSString *)extraAsString
{
    switch (self.extra) {
        case KPBMealExtraDessert: return NSLocalizedString(@"dessert", nil);
        case KPBMealExtraSoup: return NSLocalizedString(@"soup", nil);
        case KPBMealExtraNone: return nil;
    }
    return nil;
}

@end

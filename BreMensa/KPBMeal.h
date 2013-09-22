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

+ (instancetype)mealFromDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *staffPrice;
@property (nonatomic, copy) NSString *studentPrice;
@property (nonatomic) KPBMealType type;
@property (nonatomic) KPBMealExtra extra;
@property (nonatomic) NSInteger serverId;

- (NSString *)typeAsString;
- (NSString *)extraAsString;

- (NSString *)priceText;
- (NSString *)infoText;

@end

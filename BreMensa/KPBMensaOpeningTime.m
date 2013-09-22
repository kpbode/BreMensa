#import "KPBMensaOpeningTime.h"

@implementation KPBMensaOpeningTime

+ (instancetype)openingTimeFromDictionary:(NSDictionary *)dictionary
{
    KPBMensaOpeningTime *openingTime = [[KPBMensaOpeningTime alloc] init];
    
    openingTime.label = dictionary[@"label"];
    openingTime.value = dictionary[@"value"];
    
    return openingTime;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %@", _label, _value];
}

@end

#import "KPBMensaOpeningInfo.h"
#import "KPBMensaOpeningTime.h"

@implementation KPBMensaOpeningInfo

+ (instancetype)openingInfoFromDictionary:(NSDictionary *)dictionary
{
    KPBMensaOpeningInfo *openingInfo = [[KPBMensaOpeningInfo alloc] init];
    openingInfo.title = dictionary[@"title"];
    openingInfo.subtitle = dictionary[@"subtitle"];
    
    NSMutableArray *openingTimes = [[NSMutableArray alloc] init];
    
    NSArray *openingTimeDictionaries = dictionary[@"times"];
    
    for (NSDictionary *openingTimeDictionary in openingTimeDictionaries) {
        
        KPBMensaOpeningTime *openingTime = [KPBMensaOpeningTime openingTimeFromDictionary:openingTimeDictionary];
        if (openingTime != nil) {
            [openingTimes addObject:openingTime];
        }
    }
    
    openingInfo.times = openingTimes;
    
    return openingInfo;
}

@end

#import <Foundation/Foundation.h>

@class KPBMensaOpeningTime;

@interface KPBMensaOpeningInfo : NSObject

+ (instancetype)openingInfoFromDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *subtitle;
@property (nonatomic, copy, readwrite) NSArray *times;

@end

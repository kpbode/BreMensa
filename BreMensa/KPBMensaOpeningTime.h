#import <Foundation/Foundation.h>

@interface KPBMensaOpeningTime : NSObject

+ (instancetype)openingTimeFromDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readwrite) NSString *label;
@property (nonatomic, copy, readwrite) NSString *value;

@end

#import <Foundation/Foundation.h>

@class KPBMeal;

@interface KPBMenu : NSObject <NSCoding>

@property (nonatomic) NSDate *date;
@property (nonatomic) NSInteger serverId;
@property (nonatomic, copy) NSArray *meals;

@end

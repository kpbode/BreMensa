#import "KPBMenu.h"

static NSString * const KPBMenuDateKey = @"date";
static NSString * const KPBMenuServerIdKey = @"serverId";
static NSString * const KPBMenuMealsKey = @"meals";

@implementation KPBMenu

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.date = [decoder decodeObjectForKey:KPBMenuDateKey];
        self.serverId = [decoder decodeIntegerForKey:KPBMenuServerIdKey];
        self.meals = [decoder decodeObjectForKey:KPBMenuMealsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.date forKey:KPBMenuDateKey];
    [coder encodeInteger:self.serverId forKey:KPBMenuServerIdKey];
    [coder encodeObject:self.meals forKey:KPBMenuMealsKey];
}

@end

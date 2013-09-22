#import <Foundation/Foundation.h>

@interface KPBMealplanLayoutSection : NSObject

@property (nonatomic, readonly) CGRect frame;
@property (nonatomic, readonly) UIEdgeInsets itemInsets;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger columns;

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width columns:(NSInteger)columns itemInsets:(UIEdgeInsets)itemInsets;

- (void)addItemOfSize:(CGSize)size forIndex:(NSInteger)index toColumnWithIndex:(NSInteger)columnIndex andWidth:(CGFloat)columnWidth;

- (CGRect)frameForItemAtIndex:(NSInteger)index;

@end

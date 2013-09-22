#import <UIKit/UIKit.h>

@interface KPBMenuHeaderView : UICollectionReusableView

@property (nonatomic, weak, readonly) UILabel *dayLabel;
@property (nonatomic, weak, readonly) UILabel *dateLabel;

- (void)setupBackgroundForToday:(BOOL)today;

@end

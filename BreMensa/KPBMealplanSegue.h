#import <UIKit/UIKit.h>

@class KPBMealplanSegue;

@protocol KPBMealplanSegueDelegate <NSObject>

- (void)mealplanSegue:(KPBMealplanSegue *)mealplanSegue screenshotTakenBeforeDismiss:(UIImage *)screenshot;

@end

@interface KPBMealplanSegue : UIStoryboardSegue

@property (nonatomic) CGRect targetFrame;
@property (nonatomic) CGAffineTransform shownTransform;
@property (nonatomic) CGAffineTransform hiddenTransform;
@property (nonatomic) id<KPBMealplanSegueDelegate> delegate;

@end

#import <Foundation/Foundation.h>

@class KPBPhoneMealplanPresentationAnimator;

@protocol KPBPhoneMealplanPresentationAnimatorDelegate <NSObject>

- (void)mealplanPresentationAnimator:(KPBPhoneMealplanPresentationAnimator *)animator screenshotTakenBeforeDismiss:(UIImage *)screenshot;

@end

@interface KPBPhoneMealplanPresentationAnimator : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)presentAnimator;
+ (instancetype)dismissAnimator;

@property (nonatomic) CGRect targetFrame;
@property (nonatomic) CGAffineTransform shownTransform;
@property (nonatomic) CGAffineTransform hiddenTransform;
@property (nonatomic) id<KPBPhoneMealplanPresentationAnimatorDelegate> delegate;

@end

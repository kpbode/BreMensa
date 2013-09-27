#import "KPBPhoneMealplanPresentationAnimator.h"

@interface KPBPhoneMealplanPresentationAnimator ()

@property (nonatomic) BOOL dismiss;

@end

@implementation KPBPhoneMealplanPresentationAnimator

+ (instancetype)presentAnimator
{
    KPBPhoneMealplanPresentationAnimator *animator = [[KPBPhoneMealplanPresentationAnimator alloc] init];
    animator.dismiss = NO;
    return animator;
}

+ (instancetype)dismissAnimator
{
    KPBPhoneMealplanPresentationAnimator *animator = [[KPBPhoneMealplanPresentationAnimator alloc] init];
    animator.dismiss = YES;
    return animator;
}


static NSTimeInterval const KPBPhoneMenuViewControllerTransitionDuration = .4;

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return KPBPhoneMenuViewControllerTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    if (_dismiss) {
        [self animateDismissTransition:transitionContext];
    } else {
        [self animatePresentTransition:transitionContext];
    }
}

- (void)animatePresentTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (fromViewController == nil) return;
    if (toViewController == nil) return;
    
    toViewController.view.frame = _targetFrame;
    [containerView addSubview:toViewController.view];
    
    toViewController.view.transform = _hiddenTransform;
    
    [UIView animateWithDuration:KPBPhoneMenuViewControllerTransitionDuration delay:.0 usingSpringWithDamping:1. initialSpringVelocity:1. options:0 animations:^{
    
        toViewController.view.transform = _shownTransform;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (UIImage *)takeScreenShotFromViewController:(UIViewController *)viewController
{
    CGRect bounds = viewController.view.bounds;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.f);
    
    [[UIColor colorWithWhite:.9f alpha:1.f] setFill];
    [[UIBezierPath bezierPathWithRect:bounds] fill];
    
    [viewController.view drawViewHierarchyInRect:bounds
                                  afterScreenUpdates:YES];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenshot;
}

- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    __block UIImage *screenshot = nil;
    
    double delayInSeconds = 0.11;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        screenshot = [self takeScreenShotFromViewController:fromViewController];
    });
    
    [UIView animateWithDuration:KPBPhoneMenuViewControllerTransitionDuration delay:.12 usingSpringWithDamping:.8 initialSpringVelocity:.3 options:0 animations:^{
        
        fromViewController.view.transform = _hiddenTransform;
        
    } completion:^(BOOL finished) {
        [_delegate mealplanPresentationAnimator:self screenshotTakenBeforeDismiss:screenshot];
        [transitionContext completeTransition:finished];
    }];
    
}

@end

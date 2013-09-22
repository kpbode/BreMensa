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

- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{

    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIGraphicsBeginImageContextWithOptions(fromViewController.view.bounds.size, YES, 0.f);
    
    [fromViewController.view drawViewHierarchyInRect:fromViewController.view.bounds
                                  afterScreenUpdates:YES];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [_delegate mealplanPresentationAnimator:self screenshotTakenBeforeDismiss:screenshot];
    
    [UIView animateWithDuration:KPBPhoneMenuViewControllerTransitionDuration delay:.0 usingSpringWithDamping:1. initialSpringVelocity:1. options:0 animations:^{
        
        fromViewController.view.transform = _hiddenTransform;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
    
}

@end

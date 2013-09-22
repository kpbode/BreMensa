#import "KPBMealplanSegue.h"
#import "KPBPhoneMealplanPresentationAnimator.h"

@interface KPBMealplanSegue () <UIViewControllerTransitioningDelegate, KPBPhoneMealplanPresentationAnimatorDelegate>

@end

@implementation KPBMealplanSegue

- (void)perform
{
    
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
    destinationViewController.transitioningDelegate = self;
    destinationViewController.modalPresentationCapturesStatusBarAppearance = YES;
    
    [sourceViewController presentViewController:destinationViewController animated:YES completion:nil];
}

# pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    
    KPBPhoneMealplanPresentationAnimator *animator = [KPBPhoneMealplanPresentationAnimator presentAnimator];
    animator.targetFrame = _targetFrame;
    animator.shownTransform = _shownTransform;
    animator.hiddenTransform = _hiddenTransform;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    KPBPhoneMealplanPresentationAnimator *animator = [KPBPhoneMealplanPresentationAnimator dismissAnimator];
    animator.targetFrame = _targetFrame;
    animator.shownTransform = _shownTransform;
    animator.hiddenTransform = _hiddenTransform;
    animator.delegate = self;
    
    return animator;
}

#pragma mark KPBPhoneMealplanPresentationAnimatorDelegate

- (void)mealplanPresentationAnimator:(KPBPhoneMealplanPresentationAnimator *)animator screenshotTakenBeforeDismiss:(UIImage *)screenshot
{
    [_delegate mealplanSegue:self screenshotTakenBeforeDismiss:screenshot];
}

@end

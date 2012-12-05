//
//  KPBPadNavigationManager.m
//  BreMensa
//
//  Created by Karl Bode on 03.12.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBPadNavigationManager.h"
#import "KPBPickMensaViewController.h"
#import "KPBMealplanViewController.h"
#import "KPBMoreInfoViewController.h"
#import "KPBMensaDetailViewController.h"

@interface KPBPadNavigationManager () <UISplitViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong, readwrite) UISplitViewController *splitViewController;
@property (nonatomic, strong, readwrite) KPBPickMensaViewController *pickMensaViewController;
@property (nonatomic, strong, readwrite) KPBMealplanViewController *mealplanViewController;
@property (nonatomic, strong, readwrite) UIPopoverController *masterPopoverController;
@property (nonatomic, strong, readwrite) UIPopoverController *popoverController;

@end

@implementation KPBPadNavigationManager

- (UIViewController *)rootViewController
{
    return self.splitViewController;
}

- (UISplitViewController *)splitViewController
{
    if (_splitViewController != nil) return _splitViewController;
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    
    KPBPickMensaViewController *pickMensaViewController = [[KPBPickMensaViewController alloc] init];
    
    self.pickMensaViewController = pickMensaViewController;
    
    UINavigationController *pickMensaNavigationController = [[UINavigationController alloc] initWithRootViewController:pickMensaViewController];
    
    KPBMealplanViewController *mealPlanViewController = [[KPBMealplanViewController alloc] init];
    
    mealPlanViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info"
                                                                                                style:UIBarButtonItemStyleBordered
                                                                                               target:self action:@selector(onShowMensaInfo:)];
    
    KPBMensa *lastViewedMensa = [self lastViewedMensa];
    if (lastViewedMensa != nil) {
        [mealPlanViewController showMealplanForMensa:lastViewedMensa];
    }
    
    self.mealplanViewController = mealPlanViewController;
    
    UINavigationController *mealPlanNavigationController = [[UINavigationController alloc] initWithRootViewController:mealPlanViewController];
    
    splitViewController.viewControllers = @[ pickMensaNavigationController, mealPlanNavigationController ];
    splitViewController.delegate = self;
    splitViewController.presentsWithGesture = YES;
    
    self.splitViewController = splitViewController;
    
    return _splitViewController;
}

- (void)showMealplanForMensa:(KPBMensa *)mensa
{
    [super showMealplanForMensa:mensa];
    
    if (mensa == nil) return;
    
    [self.mealplanViewController showMealplanForMensa:mensa];
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)showMoreInfo
{
    [super showMoreInfo];
    
    if (self.popoverController != nil && [self.popoverController.contentViewController isKindOfClass:[KPBMoreInfoViewController class]]) return;
    
    [self hidePopoverIfShowing];
    
    KPBMoreInfoViewController *moreInfoViewController = [[KPBMoreInfoViewController alloc] init];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:moreInfoViewController];
    popoverController.delegate = self;
    
    CGRect buttonRect = self.pickMensaViewController.moreInfoButton.frame;
    buttonRect.origin.y += CGRectGetHeight(self.pickMensaViewController.navigationController.navigationBar.frame) + 20.f;
    
    [popoverController presentPopoverFromRect:buttonRect inView:self.splitViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    self.popoverController = popoverController;
    
}

- (void)showDetailsForMensa:(KPBMensa *)mensa
{
    [super showDetailsForMensa:mensa];
    
    if (mensa == nil) return;
    
    if (self.popoverController != nil && [self.popoverController.contentViewController isKindOfClass:[KPBMensaDetailViewController class]]) return;
    
    [self hidePopoverIfShowing];
    
    KPBMensaDetailViewController *mensaDetailViewController = [[KPBMensaDetailViewController alloc] initWithMensa:mensa];
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:mensaDetailViewController];
    popoverController.delegate = self;
    
    [popoverController presentPopoverFromBarButtonItem:self.mealplanViewController.navigationItem.rightBarButtonItem
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    
    self.popoverController = popoverController;
    
}

- (void)onShowMenu:(id)sender
{
    [self.masterPopoverController presentPopoverFromBarButtonItem:self.mealplanViewController.navigationItem.leftBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)onShowMensaInfo:(id)sender
{
    [self showDetailsForMensa:self.mealplanViewController.mensa];
}

- (void)hidePopoverIfShowing
{
    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark UISplitViewController

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (aViewController == self.pickMensaViewController.navigationController) {
        self.mealplanViewController.navigationItem.leftBarButtonItem = nil;
        self.masterPopoverController = nil;
    }
    
    [self hidePopoverIfShowing];
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    if (aViewController == self.pickMensaViewController.navigationController) {
        self.mealplanViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                                                      style:UIBarButtonItemStyleBordered
                                                                                                     target:self action:@selector(onShowMenu:)];
        self.masterPopoverController = pc;
    }
    
    [self hidePopoverIfShowing];
}

#pragma mark UIPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.popoverController) {
        self.popoverController = nil;
    }
}

@end

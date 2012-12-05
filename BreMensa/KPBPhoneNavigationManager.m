//
//  KPBPhoneNavigationManager.m
//  BreMensa
//
//  Created by Karl Bode on 03.12.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBPhoneNavigationManager.h"
#import "KPBPickMensaViewController.h"
#import "KPBMealplanViewController.h"
#import "KPBMensaDetailViewController.h"
#import "KPBMoreInfoViewController.h"

@interface KPBPhoneNavigationManager () <UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) UINavigationController *navigationController;

@end

@implementation KPBPhoneNavigationManager

- (UIViewController *)rootViewController
{
    return self.navigationController;
}

- (UINavigationController *)navigationController
{
    if (_navigationController != nil) return _navigationController;
    
    KPBPickMensaViewController *pickMensaViewController = [[KPBPickMensaViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pickMensaViewController];
    navigationController.delegate = self;
    
    KPBMensa *lastViewedMensa = [self lastViewedMensa];
    if (lastViewedMensa != nil) {
        KPBMealplanViewController *mealplanViewController = [[KPBMealplanViewController alloc] init];
        [navigationController pushViewController:mealplanViewController animated:NO];
        [mealplanViewController showMealplanForMensa:lastViewedMensa];
    }
    
    self.navigationController = navigationController;
    
    return _navigationController;
}

- (void)showMealplanForMensa:(KPBMensa *)mensa
{
    [super showMealplanForMensa:mensa];
    
    if (mensa == nil) return;
    
    KPBMealplanViewController *mealPlanViewController = [[KPBMealplanViewController alloc] init];
    [self.navigationController pushViewController:mealPlanViewController animated:YES];
    [mealPlanViewController showMealplanForMensa:mensa];
}

- (void)showDetailsForMensa:(KPBMensa *)mensa
{
    [super showDetailsForMensa:mensa];
    
    if (mensa == nil) return;
    
    KPBMensaDetailViewController *detailViewController = [[KPBMensaDetailViewController alloc] initWithMensa:mensa];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)showMoreInfo
{
    [super showMoreInfo];
    KPBMoreInfoViewController *moreInfoViewController = [[KPBMoreInfoViewController alloc] init];
    [self.navigationController pushViewController:moreInfoViewController animated:YES];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[KPBPickMensaViewController class]]) {
        [self resetLastViewedMensa];
    }
}

@end

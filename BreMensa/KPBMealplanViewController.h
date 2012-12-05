//
//  KPBMealplanViewController.h
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSTCollectionView/PSTCollectionView.h>

@class KPBMensa;

@interface KPBMealplanViewController : PSUICollectionViewController

@property (nonatomic, strong, readonly) KPBMensa *mensa;

- (void)showMealplanForMensa:(KPBMensa *)mensa;

@end

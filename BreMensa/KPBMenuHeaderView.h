//
//  KPBMenuHeaderView.h
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSTCollectionView/PSTCollectionView.h>

@interface KPBMenuHeaderView : PSUICollectionReusableView

@property (nonatomic, weak, readonly) UILabel *dayLabel;
@property (nonatomic, weak, readonly) UILabel *dateLabel;

- (void)setupBackgroundForToday:(BOOL)today;

@end

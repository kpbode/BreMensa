//
//  KPBMealCell.h
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PSTCollectionView/PSTCollectionView.h>

@interface KPBMealCell : PSUICollectionViewCell

+ (CGFloat)heightForWidth:(CGFloat)width title:(NSString *)title text:(NSString *)text priceText:(NSString *)priceText andInfoText:(NSString *)infoText;

@property (nonatomic, weak, readonly) UILabel *mealTitleLabel;
@property (nonatomic, weak, readonly) UILabel *mealTextLabel;
@property (nonatomic, weak, readonly) UILabel *priceTextLabel;
@property (nonatomic, weak, readonly) UILabel *infoTextLabel;

@end

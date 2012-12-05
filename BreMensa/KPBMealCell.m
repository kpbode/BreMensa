//
//  KPBMealCell.m
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMealCell.h"

@interface KPBMealCell ()

@property (nonatomic, weak, readwrite) UILabel *mealTitleLabel;
@property (nonatomic, weak, readwrite) UILabel *mealTextLabel;
@property (nonatomic, weak, readwrite) UILabel *priceTextLabel;
@property (nonatomic, weak, readwrite) UILabel *infoTextLabel;

@end

@implementation KPBMealCell

static UIFont *TitleFont;
static UIFont *TextFont;
static UIFont *PriceFont;
static UIFont *InfoFont;
static UIImage *BackgroundImage;

+ (void)initialize
{
    TitleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:IS_IPHONE ? 15.f : 20.f];
    TextFont = [UIFont fontWithName:@"HelveticaNeue" size:IS_IPHONE ? 14.f : 19.f];
    PriceFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:IS_IPHONE ? 10.f : 15.f];
    InfoFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:IS_IPHONE ? 10.f : 15.f];
    BackgroundImage = [[UIImage imageNamed:@"meal_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.f, 4.f, 16.f, 17.f)];
}

+ (CGFloat)heightForWidth:(CGFloat)width
                    title:(NSString *)title
                     text:(NSString *)text
                priceText:(NSString *)priceText
              andInfoText:(NSString *)infoText
{
    
    CGFloat targetWidth = width - 20.f;
    
    CGFloat height = 10.f;
    
    CGSize titleSize = [title sizeWithFont:TitleFont forWidth:targetWidth lineBreakMode:NSLineBreakByClipping];
    
    height += titleSize.height + 10.f;
    
    CGSize textSize = [text sizeWithFont:TextFont constrainedToSize:CGSizeMake(targetWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByClipping];
    
    height += textSize.height + 10.f;
    
    CGSize priceSize = [priceText sizeWithFont:PriceFont forWidth:targetWidth lineBreakMode:NSLineBreakByClipping];
    
    height += priceSize.height + 10.f;
    
    if (infoText != nil && [infoText length] > 0) {
        CGSize infoSize = [infoText sizeWithFont:InfoFont forWidth:targetWidth lineBreakMode:NSLineBreakByClipping];
        height += infoSize.height + 10.f;
    }
    
    return height;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:BackgroundImage];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.backgroundView = backgroundView;
        
        UILabel *mealTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mealTitleLabel.backgroundColor = [UIColor clearColor];
        mealTitleLabel.font = TitleFont;
        
        [self.contentView addSubview:mealTitleLabel];
        self.mealTitleLabel = mealTitleLabel;
        
        UILabel *mealTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        mealTextLabel.backgroundColor = [UIColor clearColor];
        mealTextLabel.numberOfLines = 0;
        mealTextLabel.font = TextFont;
        
        [self.contentView addSubview:mealTextLabel];
        self.mealTextLabel = mealTextLabel;
        
        UILabel *priceTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceTextLabel.backgroundColor = [UIColor clearColor];
        priceTextLabel.font = PriceFont;
        
        [self.contentView addSubview:priceTextLabel];
        self.priceTextLabel = priceTextLabel;
        
        
        UILabel *infoTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoTextLabel.backgroundColor = [UIColor clearColor];
        infoTextLabel.font = InfoFont;
        
        [self.contentView addSubview:infoTextLabel];
        self.infoTextLabel = infoTextLabel;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundView.frame = self.bounds;
    
    CGFloat contentWidth = CGRectGetWidth(self.contentView.bounds) - 20.f;
    
    CGFloat insetX = 10.f;
    
    CGSize titleSize = [self.mealTitleLabel.text sizeWithFont:self.mealTitleLabel.font
                                                     forWidth:contentWidth
                                                lineBreakMode:NSLineBreakByClipping];
    CGRect titleLabelFrame = CGRectMake(insetX, 10.f, titleSize.width, titleSize.height);
    self.mealTitleLabel.frame = CGRectIntegral(titleLabelFrame);
    
    CGSize mealTextSize = [self.mealTextLabel.text sizeWithFont:self.mealTextLabel.font
                                              constrainedToSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                  lineBreakMode:NSLineBreakByClipping];
    CGRect mealTextLabelFrame = CGRectMake(insetX, CGRectGetMaxY(titleLabelFrame) + 10.f, mealTextSize.width, mealTextSize.height);
    self.mealTextLabel.frame = CGRectIntegral(mealTextLabelFrame);
    
    
    CGSize priceSize = [self.priceTextLabel.text sizeWithFont:self.priceTextLabel.font
                                                     forWidth:contentWidth
                                                lineBreakMode:NSLineBreakByClipping];
    CGRect priceLabelFrame = CGRectMake(insetX, CGRectGetMaxY(mealTextLabelFrame) + 10.f, priceSize.width, priceSize.height);
    self.priceTextLabel.frame = CGRectIntegral(priceLabelFrame);
    
    
    CGSize infoSize = [self.infoTextLabel.text sizeWithFont:self.infoTextLabel.font
                                                   forWidth:contentWidth
                                              lineBreakMode:NSLineBreakByClipping];
    CGRect infoLabelFrame = CGRectMake(insetX, CGRectGetMaxY(priceLabelFrame) + 10.f, infoSize.width, infoSize.height);
    self.infoTextLabel.frame = CGRectIntegral(infoLabelFrame);
}

@end

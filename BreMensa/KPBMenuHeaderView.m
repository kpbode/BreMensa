//
//  KPBMenuHeaderView.m
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMenuHeaderView.h"

@interface KPBMenuHeaderView ()

@property (nonatomic, weak, readwrite) UILabel *dayLabel;
@property (nonatomic, weak, readwrite) UILabel *dateLabel;
@property (nonatomic, weak, readwrite) UIImageView *backgroundView;

@end

@implementation KPBMenuHeaderView

static UIFont *DayLabelFont;
static UIFont *DateLabelFont;
static UIImage *BackgroundImage;
static UIImage *BackgroundImageToday;

+ (void)initialize
{
    DayLabelFont = [UIFont fontWithName:@"HelveticaNeue" size:IS_IPHONE ? 18.f : 23.f];
    DateLabelFont = [UIFont fontWithName:@"HelveticaNeue-Italic" size:IS_IPHONE ? 14.f : 19.f];
    BackgroundImage = [[UIImage imageNamed:@"meal_header_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.f, 4.f, 16.f, 17.f)];
    BackgroundImageToday = [[UIImage imageNamed:@"meal_header_today_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.f, 4.f, 16.f, 17.f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = BackgroundImage;
        
        [self addSubview:backgroundView];
        self.backgroundView = backgroundView;
        
        CGRect dayLabelFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dayLabel.textAlignment = UITextAlignmentCenter;
        dayLabel.font = DayLabelFont;
        dayLabel.textColor = [UIColor whiteColor];
        [self addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
        CGRect dateLabelFrame = CGRectMake(0.f, CGRectGetMaxY(dayLabelFrame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(dayLabelFrame));
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dateLabel.textAlignment = UITextAlignmentCenter;
        dateLabel.font = DateLabelFont;
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
    }
    return self;
}

- (void)setupBackgroundForToday:(BOOL)today
{
    self.backgroundView.image = today ? BackgroundImageToday : BackgroundImage;
}

@end

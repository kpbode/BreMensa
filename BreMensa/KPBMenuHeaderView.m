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

@end

@implementation KPBMenuHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.196 alpha:1];
        
        CGRect dayLabelFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
        
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:dayLabelFrame];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dayLabel.textAlignment = UITextAlignmentCenter;
        dayLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.f];
        dayLabel.textColor = [UIColor whiteColor];
        [self addSubview:dayLabel];
        self.dayLabel = dayLabel;
        
        CGRect dateLabelFrame = CGRectMake(0.f, CGRectGetMaxY(dayLabelFrame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(dayLabelFrame));
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        dateLabel.textAlignment = UITextAlignmentCenter;
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
        dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:dateLabel];
        self.dateLabel = dateLabel;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

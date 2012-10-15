//
//  KPBMenuHeaderCell.m
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMenuHeaderCell.h"

@interface KPBMenuHeaderCell ()

@property (nonatomic, weak, readwrite) UILabel *titleLabel;
@property (nonatomic, weak, readwrite) UILabel *subtitleLabel;

@end

@implementation KPBMenuHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect titleLabelFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2.f);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.f];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        CGRect subtitleLabelFrame = CGRectMake(0.f, CGRectGetMaxY(titleLabelFrame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(titleLabelFrame));
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:subtitleLabelFrame];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        subtitleLabel.textAlignment = UITextAlignmentCenter;
        subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
        [self.contentView addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
    }
    return self;
}

@end

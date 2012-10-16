//
//  KPBMealplanInfoView.m
//  BreMensa
//
//  Created by Karl Bode on 14.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMealplanInfoView.h"

@interface KPBMealplanInfoView ()

@property (nonatomic, weak, readwrite) UILabel *textLabel;

@end

@implementation KPBMealplanInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.200 green:0.200 blue:0.196 alpha:1];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 10.f, 0.f)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont fontWithName:@"HelveticeNeue" size:12.f];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
    }
    return self;
}

@end

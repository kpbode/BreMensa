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
        
        self.backgroundColor = [UIColor greenColor];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
    }
    return self;
}

@end

//
//  KPBMealplanLayoutSection.h
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPBMealplanLayoutSection : NSObject

@property (nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, assign, readonly) UIEdgeInsets itemInsets;
@property (nonatomic, assign, readonly) NSInteger numberOfItems;

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width columns:(NSInteger)columns itemInsets:(UIEdgeInsets)itemInsets;

- (void)addItemOfSize:(CGSize)size forIndex:(NSInteger)index toColumnWithWidth:(CGFloat)columnWidth;

- (CGRect)frameForItemAtIndex:(NSInteger)index;

@end

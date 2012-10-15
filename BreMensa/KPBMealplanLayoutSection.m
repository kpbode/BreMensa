//
//  KPBMealplanLayoutSection.m
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMealplanLayoutSection.h"

@interface KPBMealplanLayoutSection ()

@property (nonatomic, assign, readwrite) CGRect frame;
@property (nonatomic, assign, readwrite) UIEdgeInsets itemInsets;
@property (nonatomic, strong, readwrite) NSMutableArray *columnHeights;
@property (nonatomic, strong, readwrite) NSMutableDictionary *indexToFrameMap;
@property (nonatomic, assign, readwrite) NSInteger columns;

@end

@implementation KPBMealplanLayoutSection

- (id)initWithOrigin:(CGPoint)origin width:(CGFloat)width columns:(NSInteger)columns itemInsets:(UIEdgeInsets)itemInsets
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(origin.x, origin.y, width, 0.f);
        self.itemInsets = itemInsets;
        self.columnHeights = [[NSMutableArray alloc] init];
        self.columns = columns;
        
        for (NSInteger i = 0; i < columns; i++) {
            [self.columnHeights addObject:@0.f];
        }
        
        self.indexToFrameMap = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)addItemOfSize:(CGSize)size forIndex:(NSInteger)index toColumnWithWidth:(CGFloat)columnWidth
{
    __block CGFloat shortestColumnHeight = CGFLOAT_MAX;
    __block NSInteger shortestColumnIndex = 0;
    
    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger index, BOOL *stop) {
        CGFloat columnHeight = [columnHeightNumber floatValue];
        if (columnHeight < shortestColumnHeight) {
            shortestColumnHeight = columnHeight;
            shortestColumnIndex = index;
        }
    }];
    
    CGRect frame = CGRectMake(columnWidth * shortestColumnIndex, shortestColumnHeight, size.width, size.height);
    frame = CGRectOffset(frame, CGRectGetMinX(self.frame) + self.itemInsets.left, CGRectGetMinY(self.frame) + self.itemInsets.top);
    
    self.indexToFrameMap[@(index)] = [NSValue valueWithCGRect:frame];
    
//    NSLog(@"item(%i).frame: %@", index, NSStringFromCGRect(frame));
    
    if (CGRectGetMaxY(frame) > CGRectGetMaxY(self.frame)) {
        CGFloat newHeight = CGRectGetMaxY(frame) - CGRectGetMinY(self.frame) + self.itemInsets.bottom;
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), newHeight);
    }
    
    CGFloat columnHeight = shortestColumnHeight + size.height + self.itemInsets.bottom;
    
    [self.columnHeights replaceObjectAtIndex:shortestColumnIndex withObject:@(columnHeight)];
}

- (NSInteger)numberOfItems
{
    return [self.indexToFrameMap count];
}

- (CGRect)frameForItemAtIndex:(NSInteger)index
{
    return [self.indexToFrameMap[@(index)] CGRectValue];
}

@end

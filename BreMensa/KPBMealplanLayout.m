//
//  KPBMealplanLayout.m
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMealplanLayout.h"
#import "KPBMealplanLayoutSection.h"

@interface KPBMealplanLayout ()

@property (nonatomic, copy, readwrite) NSArray *sectionData;
@property (nonatomic, assign, readwrite) CGFloat width;
@property (nonatomic, assign, readwrite) CGFloat height;

@end

@implementation KPBMealplanLayout

- (void)prepareLayout
{
    [super prepareLayout];

    NSMutableArray *sectionData = [[NSMutableArray alloc] init];
    CGFloat height = 0.f;
    CGFloat width = 0.f;
    
    CGPoint currentOrigin = CGPointZero;
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    PSUICollectionView *collectionView = (PSUICollectionView *) self.collectionView;
    
    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        
        NSInteger numberOfColumns = [self.delegate collectionView:collectionView
                                                           layout:self
                                         numberOfColumnsInSection:sectionIndex];
        
        NSInteger numberOfItems = [collectionView numberOfItemsInSection:sectionIndex];
        
        UIEdgeInsets itemInsets = [self.delegate collectionView:collectionView
                                                          layout:self
                                     itemInsetsForSectionAtIndex:sectionIndex];
        
        CGFloat sectionWidth = 0.f;
        
        NSMutableArray *columnWidths = [[NSMutableArray alloc] init];
        
        for (NSInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++) {
            CGFloat columnWidth = [self.delegate collectionView:collectionView layout:self widthForColumn:columnIndex forSectionAtIndex:sectionIndex];
            sectionWidth += columnWidth;
            [columnWidths addObject:@(columnWidth)];
        }
        
        width = MAX(width, sectionWidth);
        
        KPBMealplanLayoutSection *section = [[KPBMealplanLayoutSection alloc] initWithOrigin:currentOrigin
                                                                                       width:sectionWidth
                                                                                     columns:numberOfColumns
                                                                                  itemInsets:itemInsets];
        
        for (NSInteger itemIndex = 0; itemIndex < numberOfItems; itemIndex++) {
            
            NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            
            NSInteger columnIndex = [self.delegate collectionView:collectionView
                                                           layout:self
                                    columnIndexForItemAtIndexPath:itemIndexPath];
            
            CGFloat columnWidth = [columnWidths[columnIndex] floatValue];
            
            CGFloat itemWidth = columnWidth - section.itemInsets.left - section.itemInsets.right;
            
            CGSize itemSize  = [self.delegate collectionView:collectionView
                                                      layout:self
                                        sizeForItemWithWidth:itemWidth
                                                 atIndexPath:itemIndexPath];
            
            //NSLog(@"item(%i).size: %@", itemIndex, NSStringFromCGSize(itemSize));
            
            [section addItemOfSize:itemSize forIndex:itemIndex toColumnWithWidth:columnWidth];
        }
        
        [sectionData addObject:section];
        
        height += CGRectGetHeight(section.frame);
        currentOrigin.y = height;
        
    }
    
    height += self.footerHeight;
    
    self.sectionData = sectionData;
    self.width = width;
    self.height = height;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.width, self.height);
}

- (PSUICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    KPBMealplanLayoutSection *section = self.sectionData[indexPath.section];
    PSUICollectionViewLayoutAttributes *layoutAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = [section frameForItemAtIndex:indexPath.item];
    
    return layoutAttributes;
}

- (PSUICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    KPBMealplanLayoutSection *section = self.sectionData[indexPath.section];
    PSUICollectionViewLayoutAttributes *layoutAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGRect sectionFrame = section.frame;
    CGRect footerFrame = CGRectMake(0.f, CGRectGetMaxY(sectionFrame), CGRectGetWidth(sectionFrame), self.footerHeight);
    
    layoutAttributes.frame = footerFrame;
    
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    
    [self.sectionData enumerateObjectsUsingBlock:^(KPBMealplanLayoutSection *section, NSUInteger sectionIndex, BOOL *stop) {
        
        CGRect sectionFrame = section.frame;
        CGRect footerFrame = CGRectMake(0.f, CGRectGetMaxY(sectionFrame), CGRectGetWidth(sectionFrame), self.footerHeight);
        
        if (CGRectIntersectsRect(footerFrame, rect)) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
            PSUICollectionViewLayoutAttributes *layoutAttributes = (PSUICollectionViewLayoutAttributes *) [self layoutAttributesForSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter
                                                                                                                                               atIndexPath:indexPath];
            [attributes addObject:layoutAttributes];
        }
        
        if (CGRectIntersectsRect(sectionFrame, rect)) {
            
            for (NSInteger index = 0; index < section.numberOfItems; index++) {
                
                CGRect itemFrame = [section frameForItemAtIndex:index];
                if (CGRectIntersectsRect(itemFrame, rect)) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:sectionIndex];
                    
                    PSUICollectionViewLayoutAttributes *layoutAttributes = (PSUICollectionViewLayoutAttributes *) [self layoutAttributesForItemAtIndexPath:indexPath];
                    [attributes addObject:layoutAttributes];
                }
                
            }
            
        }
        
    }];
    
    return attributes;
}

@end

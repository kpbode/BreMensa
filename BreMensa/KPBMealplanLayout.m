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

@property (nonatomic, copy, readwrite) NSArray *sections;
@property (nonatomic, assign, readwrite) CGFloat width;
@property (nonatomic, assign, readwrite) CGFloat height;

@end

@implementation KPBMealplanLayout

- (void)prepareLayout
{
    [super prepareLayout];

    NSMutableArray *sections = [[NSMutableArray alloc] init];
    CGFloat height = 0.f;
    CGFloat width = 0.f;
    
    CGPoint currentOrigin = CGPointZero;
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    PSUICollectionView *collectionView = (PSUICollectionView *) self.collectionView;
    
    currentOrigin.y += 50.f;
    height = 50.f;
    
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
        
        [sections addObject:section];
        
        height += CGRectGetHeight(section.frame);
        currentOrigin.y = height;
        
    }
    
    height += self.footerHeight;
    
    self.sections = sections;
    self.width = width;
    self.height = height;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.width, self.height);
}

- (PSUICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    KPBMealplanLayoutSection *section = self.sections[indexPath.section];
    PSUICollectionViewLayoutAttributes *layoutAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = [section frameForItemAtIndex:indexPath.item];
    
    return layoutAttributes;
}

- (PSUICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    KPBMealplanLayoutSection *section = self.sections[indexPath.section];
    PSUICollectionViewLayoutAttributes *layoutAttributes = [PSUICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    PSUICollectionView *collectionView = (PSUICollectionView *) self.collectionView;
    
    UIEdgeInsets insets = [self.delegate collectionView:collectionView
                                                 layout:self
                        insetsForSupplementaryViewOfKind:kind
                                             atIndexPath:indexPath];
    
    CGRect sectionFrame = section.frame;
    
    if ([PSTCollectionElementKindSectionFooter isEqualToString:kind]) {
        CGRect footerFrame = CGRectMake(0.f, CGRectGetMaxY(sectionFrame), CGRectGetWidth(sectionFrame), self.footerHeight);
        layoutAttributes.frame = footerFrame;
    } else if ([PSTCollectionElementKindSectionHeader isEqualToString:kind]) {
        
        CGFloat columnWidth = [self.delegate collectionView:collectionView
                                                     layout:self
                                             widthForColumn:indexPath.item
                                          forSectionAtIndex:indexPath.section];
        
        CGSize headerSize = [self.delegate collectionView:collectionView
                                                   layout:self
                                   sizeForHeaderWithWidth:columnWidth atIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(indexPath.item * columnWidth, collectionView.contentOffset.y, headerSize.width, headerSize.height);
        layoutAttributes.zIndex = 1024;
    }
    
    layoutAttributes.frame = UIEdgeInsetsInsetRect(layoutAttributes.frame, insets);
    
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    
    [self.sections enumerateObjectsUsingBlock:^(KPBMealplanLayoutSection *section, NSUInteger sectionIndex, BOOL *stop) {
        
        CGRect sectionFrame = section.frame;
        
        
        
        for (NSInteger column = 0; column < section.columns; column++) {
            
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:column inSection:sectionIndex];
            PSUICollectionViewLayoutAttributes *layoutAttributes = (PSUICollectionViewLayoutAttributes *) [self layoutAttributesForSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader
                                                                                                                                               atIndexPath:indexPath];
            
            CGRect headerFrame = layoutAttributes.frame;
            
            if (CGRectIntersectsRect(headerFrame, rect)) {
                [attributes addObject:layoutAttributes];
            }
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
        PSUICollectionViewLayoutAttributes *footerLayoutAttributes = (PSUICollectionViewLayoutAttributes *) [self layoutAttributesForSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter
                                                                                                                                                 atIndexPath:indexPath];
        
        CGRect footerFrame = footerLayoutAttributes.frame;
        
        if (CGRectIntersectsRect(footerFrame, rect)) {
            [attributes addObject:footerLayoutAttributes];
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

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end

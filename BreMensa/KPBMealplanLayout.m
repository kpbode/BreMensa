#import "KPBMealplanLayout.h"
#import "KPBMealplanLayoutSection.h"

@interface KPBMealplanLayout ()

@property (nonatomic, copy, readwrite) NSArray *sections;
@property (nonatomic, assign, readwrite) CGFloat width;
@property (nonatomic, assign, readwrite) CGFloat height;

@end

@implementation KPBMealplanLayout

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.footerHeight = 30.f;
    }
    return self;
}

- (id<KPBMealplanLayoutDelegate>)delegate
{
    return (id<KPBMealplanLayoutDelegate>) self.collectionView.delegate;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    UICollectionView *collectionView = self.collectionView;
    
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    CGFloat height = 0.f;
    CGFloat width = 0.f;
    
    CGPoint currentOrigin = CGPointZero;
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    
    for (NSInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        
        NSInteger numberOfColumns = [self.delegate collectionView:collectionView
                                                           layout:self
                                         numberOfColumnsInSection:sectionIndex];
        
        if (numberOfColumns == 0) continue;
        
        
        NSInteger numberOfItems = [collectionView numberOfItemsInSection:sectionIndex];
        
        UIEdgeInsets itemInsets = [self.delegate collectionView:collectionView
                                                          layout:self
                                     itemInsetsForSectionAtIndex:sectionIndex];
        
        CGFloat sectionWidth = 0.f;
        
        NSMutableArray *columnWidths = [[NSMutableArray alloc] init];
        
        CGFloat maxHeaderHeight = CGFLOAT_MIN;
        
        for (NSInteger columnIndex = 0; columnIndex < numberOfColumns; columnIndex++) {
            
            CGFloat columnWidth = [self.delegate collectionView:collectionView layout:self widthForColumn:columnIndex forSectionAtIndex:sectionIndex];
            sectionWidth += columnWidth;
            [columnWidths addObject:@(columnWidth)];
            
            CGSize headerSize = [self.delegate collectionView:collectionView
                                                       layout:self
                                       sizeForHeaderWithWidth:columnWidth
                                                  atIndexPath:[NSIndexPath indexPathForItem:columnIndex inSection:sectionIndex]];
            
            maxHeaderHeight = MAX(maxHeaderHeight, headerSize.height);
            
        }
        
        width = MAX(width, sectionWidth);
        
        currentOrigin.y += maxHeaderHeight;
        height = maxHeaderHeight;
        
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
            
            [section addItemOfSize:itemSize forIndex:itemIndex toColumnWithIndex:columnIndex andWidth:columnWidth];
        }
        
        [sections addObject:section];
        
        height += CGRectGetHeight(section.frame);
        currentOrigin.y = height;
        
    }
    
    height += self.footerHeight;
    
    if (collectionView.pagingEnabled) {
//        CGFloat pageHeight = CGRectGetHeight(collectionView.bounds) - collectionView.contentInset.top - collectionView.contentInset.bottom;
//        height = ceilf(height / pageHeight) * pageHeight;
    }
    
    self.sections = sections;
    self.width = width;
    self.height = height;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.width, self.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    KPBMealplanLayoutSection *section = self.sections[indexPath.section];
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = [section frameForItemAtIndex:indexPath.item];
    
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    KPBMealplanLayoutSection *section = self.sections[indexPath.section];
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    UICollectionView *collectionView = (UICollectionView *) self.collectionView;
    
    UIEdgeInsets insets = [self.delegate collectionView:collectionView
                                                 layout:self
                        insetsForSupplementaryViewOfKind:kind
                                             atIndexPath:indexPath];
    
    CGRect sectionFrame = section.frame;
    
    if ([UICollectionElementKindSectionFooter isEqualToString:kind]) {
        CGRect footerFrame = CGRectMake(0.f, CGRectGetMaxY(sectionFrame), CGRectGetWidth(sectionFrame), self.footerHeight);
        layoutAttributes.frame = footerFrame;
    } else if ([UICollectionElementKindSectionHeader isEqualToString:kind]) {
        
        CGFloat columnWidth = [self.delegate collectionView:collectionView
                                                     layout:self
                                             widthForColumn:indexPath.item
                                          forSectionAtIndex:indexPath.section];
        
        CGSize headerSize = [self.delegate collectionView:collectionView
                                                   layout:self
                                   sizeForHeaderWithWidth:columnWidth atIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(indexPath.item * columnWidth, collectionView.contentInset.top + collectionView.contentOffset.y, headerSize.width, headerSize.height);
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
            UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                      atIndexPath:indexPath];
            
            CGRect headerFrame = layoutAttributes.frame;
            
            if (CGRectIntersectsRect(headerFrame, rect)) {
                [attributes addObject:layoutAttributes];
            }
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
        UICollectionViewLayoutAttributes *footerLayoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
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
                    
                    UICollectionViewLayoutAttributes *layoutAttributes = (UICollectionViewLayoutAttributes *) [self layoutAttributesForItemAtIndexPath:indexPath];
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

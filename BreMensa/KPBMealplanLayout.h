#import <UIKit/UIKit.h>
#import "KPBMealplanLayoutSection.h"

@protocol KPBMealplanLayoutDelegate <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(UICollectionViewLayout *)layout
   numberOfColumnsInSection:(NSInteger)section;

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)layout
           widthForColumn:(NSInteger)column
        forSectionAtIndex:(NSInteger)section;

- (NSInteger)collectionView:(UICollectionView *)collectionView
                     layout:(UICollectionViewLayout *)layout columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)layout
    sizeForItemWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)layout
   itemInsetsForSectionAtIndex:(NSInteger)section;

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)layout
  sizeForHeaderWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)layout insetsForSupplementaryViewOfKind:(NSString *)kind
                   atIndexPath:(NSIndexPath *)indexPath;

@end

@interface KPBMealplanLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat footerHeight;

@end

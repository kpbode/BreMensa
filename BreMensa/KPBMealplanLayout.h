//
//  KPBMealplanLayout.h
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KPBMealplanLayoutSection.h"

@protocol KPBMealplanLayoutDelegate <PSUICollectionViewDelegate>

- (NSInteger)collectionView:(PSUICollectionView *)collectionView
                     layout:(PSUICollectionViewLayout *)layout
   numberOfColumnsInSection:(NSInteger)section;

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(PSUICollectionViewLayout *)layout
           widthForColumn:(NSInteger)column
        forSectionAtIndex:(NSInteger)section;

- (NSInteger)collectionView:(PSUICollectionView *)collectionView
                     layout:(PSUICollectionViewLayout *)layout columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)collectionView:(PSUICollectionView *)collectionView
                  layout:(PSUICollectionViewLayout *)layout
    sizeForItemWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView
                        layout:(PSUICollectionViewLayout *)layout
   itemInsetsForSectionAtIndex:(NSInteger)section;

- (CGSize)collectionView:(PSUICollectionView *)collectionView
                  layout:(PSUICollectionViewLayout *)layout 
  sizeForHeaderWithWidth:(CGFloat)width
             atIndexPath:(NSIndexPath *)indexPath;

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView
                        layout:(PSUICollectionViewLayout *)layout insetsForSupplementaryViewOfKind:(NSString *)kind
                   atIndexPath:(NSIndexPath *)indexPath;

@end

@interface KPBMealplanLayout : PSUICollectionViewLayout

@property (nonatomic, assign, readwrite) CGFloat footerHeight;
@property (nonatomic, assign, readwrite) id<KPBMealplanLayoutDelegate> delegate;

@end

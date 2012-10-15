//
//  KPBMealplanViewController.m
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMealplanViewController.h"
#import "KPBMealplanLayout.h"
#import "KPBMealCell.h"
#import "KPBMenuHeaderCell.h"
#import "KPBMensaDataManager.h"
#import "KPBMealplanInfoView.h"

#define kMealCellIdentifier @"MealCell"
#define kMenuHeaderCellIdentifier @"MenuHeaderCell"
#define kMealplanInfoViewIdentifier @"MealplanInfoView"

@interface KPBMealplanViewController () <KPBMealplanLayoutDelegate>

@property (nonatomic, strong, readwrite) KPBMensa *mensa;
@property (nonatomic, strong, readwrite) KPBMealplan *mealplan;
@property (nonatomic, strong, readwrite) NSDateFormatter *menuHeaderDateFormatter;

- (void)configureCell:(PSUICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureMealCell:(KPBMealCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureMenuHeaderCell:(KPBMenuHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)onScrollToToday:(id)sender;

@end

@implementation KPBMealplanViewController

- (id)initWithMensa:(KPBMensa *)mensa
{
    KPBMealplanLayout *layout = [[KPBMealplanLayout alloc] init];
    layout.footerHeight = 30.f;
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        layout.delegate = self;
        self.mensa = mensa;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.mensa.name;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Heute" style:UIBarButtonItemStyleBordered target:self action:@selector(onScrollToToday:)];
    
    [self.collectionView registerClass:[KPBMealCell class] forCellWithReuseIdentifier:kMealCellIdentifier];
    [self.collectionView registerClass:[KPBMenuHeaderCell class] forCellWithReuseIdentifier:kMenuHeaderCellIdentifier];
    [self.collectionView registerClass:[KPBMealplanInfoView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:kMealplanInfoViewIdentifier];
    [self.collectionView registerClass:[KPBMealplanInfoView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:kMealplanInfoViewIdentifier];
    
    BOOL success = [[KPBMensaDataManager sharedManager] mealplanForMensa:self.mensa withBlock:^(KPBMealplan *mealplan) {
        if (mealplan == nil) {
         
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Achtung"
                                                                message:@"Die Daten konnten nicht abgerufen werden"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        
        self.mealplan = mealplan;
        [self.collectionView reloadData];
        
    }];
    
    if (!success) {
        NSLog(@"failed to get mealplan data");
    }
}

#pragma mark - PSTCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.mealplan == 0) return 0;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (self.mealplan == 0) return 0;
    
    NSInteger maxMeals = 0;
    for (KPBMenu *menu in self.mealplan.menus) {
        maxMeals = MAX(maxMeals, [menu.meals count]);
    }
    
    return maxMeals * 5 + 5;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSTCollectionViewDelegate

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PSUICollectionViewCell *cell = nil;
    
    if (indexPath.row < 5) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuHeaderCellIdentifier forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMealCellIdentifier forIndexPath:indexPath];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(PSUICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[KPBMenuHeaderCell class]]) {
        [self configureMenuHeaderCell:(KPBMenuHeaderCell *) cell atIndexPath:indexPath];
    } else if ([cell isKindOfClass:[KPBMealCell class]]) {
        [self configureMealCell:(KPBMealCell *) cell atIndexPath:indexPath];
    }
}

- (void)configureMenuHeaderCell:(KPBMenuHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.mealplan == nil) return;
    
    NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
    
    NSInteger day = indexPath.row % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    
    dateFormatter.dateFormat = @"cccc";
    
    cell.titleLabel.text = [dateFormatter stringFromDate:menu.date];
    
    dateFormatter.dateFormat = @"dd.MM.YYYY";
    
    cell.subtitleLabel.text = [dateFormatter stringFromDate:menu.date];
    
}

- (void)configureMealCell:(KPBMealCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.mealplan == nil) return;
    
    NSInteger day = indexPath.row % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    if (menu == nil) return;
    
    NSInteger mealIndex = indexPath.row / 5 - 1;
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    
    cell.mealTitleLabel.text = meal.title;
    cell.mealTextLabel.text = meal.text;
    cell.priceTextLabel.text = [meal priceText];
    cell.infoTextLabel.text = [meal infoText];
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    KPBMealplanInfoView *infoView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMealplanInfoViewIdentifier forIndexPath:indexPath];
    
    infoView.textLabel.text = @"bla bla bla";
    
    return infoView;
}

//
/////////////////////////////////////////////////////////////////////////////////////////////
//#pragma mark - PSTCollectionViewDelegateFlowLayout
//
//- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(200, 200);
//}
//
//- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 10.f;
//}
//
//- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 5.f;
//}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout numberOfColumnsInSection:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout itemInsetsForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10.f, 5.f, 10.f, 5.f);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 5) {
        return CGSizeMake(width, 50.f);
    }
    
    if (self.mealplan == nil) CGSizeMake(width, 80.f);
    
    NSInteger day = indexPath.row % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    if (menu == nil) return CGSizeMake(width, 80.f);
    
    NSInteger mealIndex = indexPath.row / 5 - 1;
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    CGFloat height = [KPBMealCell heightForWidth:width title:meal.title text:meal.text priceText:meal.staffPrice andInfoText:meal.extraAsString];
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(PSUICollectionReusableView *)collectionView layout:(PSUICollectionViewLayout *)layout widthForColumn:(NSInteger)column forSectionAtIndex:(NSInteger)section
{
    return 200.f;
}

- (NSInteger)collectionView:(PSUICollectionReusableView *)collectionView layout:(PSUICollectionViewLayout *)layout columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row % 5;
}

- (NSDateFormatter *)menuHeaderDateFormatter
{
    if (_menuHeaderDateFormatter != nil) return _menuHeaderDateFormatter;
    
    _menuHeaderDateFormatter = [[NSDateFormatter alloc] init];
    
    return _menuHeaderDateFormatter;
}

- (void)onScrollToToday:(id)sender
{
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    
    NSDateComponents *nowComponents = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    
    NSInteger weekday = nowComponents.weekday - 2;
    
    if (weekday >= 0 && weekday < 5) {
        [self.collectionView setContentOffset:CGPointMake(weekday * 200.f, self.collectionView.contentOffset.y) animated:YES];
    }
    
}

@end

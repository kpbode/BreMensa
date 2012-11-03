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
#import "KPBMensaDataManager.h"
#import "KPBMealplanInfoView.h"
#import "KPBMenuHeaderView.h"
#import "NSDate+HCAExtensions.h"

#define kMealCellIdentifier @"MealCell"
#define kMenuHeaderViewIdentifier @"MenuHeaderView"
#define kMealplanInfoViewIdentifier @"MealplanInfoView"

@interface KPBMealplanViewController () <KPBMealplanLayoutDelegate>

@property (nonatomic, strong, readwrite) KPBMensa *mensa;
@property (nonatomic, strong, readwrite) KPBMealplan *mealplan;
@property (nonatomic, strong, readwrite) NSDateFormatter *menuHeaderDateFormatter;

- (void)configureCell:(KPBMealCell *)cell atIndexPath:(NSIndexPath *)indexPath;

- (void)scrollToTodayAnimated:(BOOL)animated;
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
        
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.773 green:0.773 blue:0.773 alpha:1];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self.collectionView registerClass:[KPBMealCell class] forCellWithReuseIdentifier:kMealCellIdentifier];
    [self.collectionView registerClass:[KPBMenuHeaderView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionHeader withReuseIdentifier:kMenuHeaderViewIdentifier];
    [self.collectionView registerClass:[KPBMealplanInfoView class] forSupplementaryViewOfKind:PSTCollectionElementKindSectionFooter withReuseIdentifier:kMealplanInfoViewIdentifier];
    
    BOOL success = [[KPBMensaDataManager sharedManager] mealplanForMensa:self.mensa withBlock:^(KPBMealplan *mealplan) {
        if (mealplan == nil) {
         
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Achtung"
                                                                message:@"Die Daten konnten nicht abgerufen werden"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            self.mealplan = mealplan;
            [self.collectionView reloadData];
        }
    }];
    
    if (!success) {
        NSLog(@"failed to get mealplan data");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self canScrollToToday]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Heute" style:UIBarButtonItemStyleBordered target:self action:@selector(onScrollToToday:)];
    }
    
    [self scrollToTodayAnimated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.collectionView flashScrollIndicators];
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
    
    return maxMeals * 5;
}

#pragma mark - PSTCollectionViewDelegate

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KPBMealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMealCellIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(KPBMealCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if (self.mealplan == nil) return;
    
    NSInteger day = indexPath.item % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    if (menu == nil) return;
    
    NSInteger mealIndex = indexPath.item / 5;
    
    //NSString *path = [NSString stringWithFormat:@"%i : %i,%i", indexPath.item, day, mealIndex];
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    cell.mealTitleLabel.text = meal.title;
    cell.mealTextLabel.text = meal.text;
    cell.priceTextLabel.text = [meal priceText];
    cell.infoTextLabel.text = [meal infoText];
    
    UIColor *textColor = [UIColor blackColor];
    UIColor *backgroundColor = [UIColor whiteColor];
    
    if ([menu.date HCA_isToday]) {
        backgroundColor = [UIColor colorWithRed:0.165 green:0.165 blue:0.165 alpha:1];
        textColor = [UIColor whiteColor];
    }
    
    cell.backgroundColor = backgroundColor;
    
    cell.mealTitleLabel.textColor = textColor;
    cell.mealTextLabel.textColor = textColor;
    cell.priceTextLabel.textColor = textColor;
    cell.infoTextLabel.textColor = textColor;
    
}

- (PSUICollectionReusableView *)collectionView:(PSUICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([PSTCollectionElementKindSectionFooter isEqualToString:kind]) {
        KPBMealplanInfoView *infoView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMealplanInfoViewIdentifier forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
        
        dateFormatter.dateFormat = @"'Daten geladen am' dd.MM.YYYY 'um' HH:MM 'Uhr'";
        
        infoView.textLabel.text = [dateFormatter stringFromDate:self.mealplan.fetchDate];
        
        return infoView;
    } else if ([PSTCollectionElementKindSectionHeader isEqualToString:kind]) {
        KPBMenuHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kMenuHeaderViewIdentifier forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
        
        NSInteger day = indexPath.item % 5;
        
        KPBMenu *menu = self.mealplan.menus[day];
        
        dateFormatter.dateFormat = @"cccc";
        
        headerView.dayLabel.text = [dateFormatter stringFromDate:menu.date];
        
        dateFormatter.dateFormat = @"dd.MM.YYYY";
        
        headerView.dateLabel.text = [dateFormatter stringFromDate:menu.date];
        
        return headerView;
    }
    
    return nil;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout numberOfColumnsInSection:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout itemInsetsForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4.f, 2.f, 4.f, 2.f);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.mealplan == nil) CGSizeMake(width, 80.f);
    
    NSInteger day = indexPath.item % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    NSInteger mealIndex = indexPath.item / 5;
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    CGFloat height = [KPBMealCell heightForWidth:width title:meal.title text:meal.text priceText:meal.priceText andInfoText:meal.infoText];
    
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

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)layout sizeForHeaderWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, 40.f);
}

- (UIEdgeInsets)collectionView:(PSUICollectionView_ *)collectionView layout:(PSUICollectionViewLayout_ *)layout insetsForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return UIEdgeInsetsMake(0.f, 2.f, 0.f, 2.f);
}

- (NSDateFormatter *)menuHeaderDateFormatter
{
    if (_menuHeaderDateFormatter != nil) return _menuHeaderDateFormatter;
    
    _menuHeaderDateFormatter = [[NSDateFormatter alloc] init];
    
    return _menuHeaderDateFormatter;
}



- (void)onScrollToToday:(id)sender
{
    [self scrollToTodayAnimated:YES];
}

- (void)scrollToTodayAnimated:(BOOL)animated
{
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    
    NSDateComponents *nowComponents = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    
    NSInteger weekday = nowComponents.weekday - 2;
    
    if (weekday >= 0 && weekday < 5) {
        [self.collectionView setContentOffset:CGPointMake(weekday * 200.f, self.collectionView.contentOffset.y) animated:animated];
    }
    
}

- (BOOL)canScrollToToday
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    NSDateComponents *nowComponents = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    NSInteger weekday = nowComponents.weekday - 2;
    return weekday >= 0 && weekday < 5;
}

@end

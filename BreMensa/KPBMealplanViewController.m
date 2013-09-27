#import "KPBMealplanViewController.h"
#import "KPBMealplanLayout.h"
#import "KPBMensa.h"
#import "KPBMealplan.h"
#import "KPBMenu.h"
#import "KPBMeal.h"
#import "KPBMealCell.h"
#import "KPBMealplanInfoView.h"
#import "KPBMenuHeaderView.h"
#import "NSDate+KPBAdditions.h"
#import "KPBMensaDetailViewController.h"

static NSString * const KPBMealplanViewControllerMealCellIdentifier = @"MealCell";
static NSString * const KPBMealplanViewControllerMenuHeaderViewIdentifier = @"MenuHeaderView";
static NSString * const KPBMealplanViewControllerInfoViewIdentifier = @"MealplanInfoView";
static CGFloat const KPBMealplanViewControllerMenuHeaderHeight = 50.f;

@interface KPBMealplanViewController () <KPBMealplanLayoutDelegate, UIScrollViewAccessibilityDelegate>

@property (nonatomic) KPBMealplan *mealplan;
@property (nonatomic) NSDateFormatter *menuHeaderDateFormatter;
@property (nonatomic, weak) UIView *placeholderView;

@end

@implementation KPBMealplanViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accessibilityLabel = NSLocalizedString(@"Mealplan", nil);
    
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(KPBMealplanViewControllerMenuHeaderHeight, 0.f, 0.f, 0.f);
    
    [self.collectionView registerClass:[KPBMealCell class] forCellWithReuseIdentifier:KPBMealplanViewControllerMealCellIdentifier];
    [self.collectionView registerClass:[KPBMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KPBMealplanViewControllerMenuHeaderViewIdentifier];
    [self.collectionView registerClass:[KPBMealplanInfoView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:KPBMealplanViewControllerInfoViewIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContentSizeCategoryDidChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.collectionView.pagingEnabled = [KPBAppConfig isShowMealsAtFullWidthEnabled] || UIAccessibilityIsVoiceOverRunning();
    self.collectionView.directionalLockEnabled = self.collectionView.pagingEnabled;
    
    
    if (self.mensa != nil) {
        [self loadMealplan];
    } else {
        [self showNoMensaPlaceholder];
    }
    
    [self.collectionView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)setMensa:(KPBMensa *)mensa
{
    _mensa = mensa;
    self.title = mensa.name;
}

- (void)loadMealplan
{
    
    if (self.mensa == nil) {
        [self showNoMensaPlaceholder];
        return;
    }

    if (![KPBMensa isBackendReachable]) {
        
        if (![self.mensa isCurrentMealplanCached]) {
            [self showOfflinePlaceholder];
        } else {
            [self onLoadedMealplan:[self.mensa cachedMealplan]];
        }
        
        return;
    }
    
    [self hidePlaceholder];
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = NSLocalizedString(@"Mealplan is being loaded", nil);
    
    [self.mensa currentMealplanWithSuccess:^(KPBMensa *mensa, KPBMealplan *mealplan) {
        
        
        if (mealplan == nil) {
            [self showErrorPlaceholder];
        } else {
            [self onLoadedMealplan:mealplan];
        }
        
        [progressHud hide:YES];
        
    } failure:^(KPBMensa *mensa, NSError *error) {
        
        NSLog(@"failed to get mealplan data: %@", error);
        [self showErrorPlaceholder];
        [progressHud hide:YES];
    }];
    
}

- (void)onLoadedMealplan:(KPBMealplan *)mealplan
{
    
    self.mealplan = mealplan;
    [self hidePlaceholder];
    [self.collectionView reloadData];
    
    if ([self canScrollToToday]) {
        UIBarButtonItem *scrollToDayButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"today", nil)
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self action:@selector(onScrollToToday:)];
        self.navigationItem.rightBarButtonItem = scrollToDayButtonItem;
    }
    
    [self scrollToTodayAnimated:YES];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.mealplan == nil) return 0;
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (self.mealplan == nil) return 0;
    
    NSInteger maxMeals = 0;
    for (KPBMenu *menu in self.mealplan.menus) {
        maxMeals = MAX(maxMeals, [menu.meals count]);
    }
    
    return maxMeals * 5;
}

#pragma mark - PSTCollectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KPBMealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KPBMealplanViewControllerMealCellIdentifier forIndexPath:indexPath];
    
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
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    cell.mealTitleLabel.text = meal.title;
    cell.mealTextLabel.text = meal.text;
    cell.priceTextLabel.text = [meal priceText];
    cell.infoTextLabel.text = [meal infoText];
    
    UIColor *textColor = [UIColor blackColor];
    
    cell.mealTitleLabel.textColor = textColor;
    cell.mealTextLabel.textColor = textColor;
    cell.priceTextLabel.textColor = textColor;
    cell.infoTextLabel.textColor = textColor;
    
    [cell setNeedsLayout];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([UICollectionElementKindSectionFooter isEqualToString:kind]) {
        KPBMealplanInfoView *infoView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:KPBMealplanViewControllerInfoViewIdentifier forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        infoView.textLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Data loaded:", nil), [dateFormatter stringFromDate:self.mealplan.fetchDate]];
        
        return infoView;
    } else if ([UICollectionElementKindSectionHeader isEqualToString:kind]) {
        KPBMenuHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:KPBMealplanViewControllerMenuHeaderViewIdentifier forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
        
        NSInteger day = indexPath.item % 5;
        
        KPBMenu *menu = self.mealplan.menus[day];
        
        dateFormatter.dateFormat = @"cccc";
        
        headerView.dayLabel.text = [dateFormatter stringFromDate:menu.date];
        
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        headerView.dateLabel.text = [dateFormatter stringFromDate:menu.date];
        
        [headerView setupBackgroundForToday:[menu.date KPB_isTodayInCalendar:[NSCalendar KPB_germanCalendar]]];
        
        return headerView;
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout numberOfColumnsInSection:(NSInteger)section
{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout itemInsetsForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4.f, 2.f, 4.f, 2.f);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    if (_mealplan == nil) return CGSizeMake(width, 80.f);
    
    NSInteger day = indexPath.item % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    NSInteger mealIndex = indexPath.item / 5;
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    CGFloat height = [KPBMealCell heightForWidth:width title:meal.title text:meal.text priceText:meal.priceText andInfoText:meal.infoText];
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout widthForColumn:(NSInteger)column forSectionAtIndex:(NSInteger)section
{
    return collectionView.pagingEnabled ? 320.f : 200.f;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row % 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForHeaderWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, KPBMealplanViewControllerMenuHeaderHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout insetsForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return UIEdgeInsetsMake(0.f, 1.f, 0.f, 1.f);
}

- (NSDateFormatter *)menuHeaderDateFormatter
{
    if (_menuHeaderDateFormatter != nil) return _menuHeaderDateFormatter;
    
    _menuHeaderDateFormatter = [[NSDateFormatter alloc] init];
//    _menuHeaderDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"de_DE"];
    
    return _menuHeaderDateFormatter;
}



- (void)onScrollToToday:(id)sender
{
    [self scrollToTodayAnimated:YES];
}

- (NSInteger)currentWeekday
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar KPB_germanCalendar];
    
    NSDateComponents *nowComponents = [calendar components:NSWeekdayCalendarUnit fromDate:now];
    
    return nowComponents.weekday - 2;
}

- (void)scrollToTodayAnimated:(BOOL)animated
{
    if (self.mealplan == nil) return;
    
    NSInteger weekday = [self currentWeekday];
    
    if (weekday >= 0 && weekday < 5) {
        
        CGFloat columnWidth = [self collectionView:(UICollectionView *) self.collectionView
                                            layout:(UICollectionViewLayout *) self.collectionView.collectionViewLayout
                                    widthForColumn:weekday forSectionAtIndex:0];
        
        CGFloat offsetX = weekday * columnWidth - (CGRectGetWidth(self.collectionView.bounds) - columnWidth) / 2.f;
        
        offsetX = MIN(offsetX, (5*columnWidth) - CGRectGetWidth(self.collectionView.bounds));
        
        if (offsetX < 0.f) {
            offsetX = 0.f;
        }
        
        [self.collectionView setContentOffset:CGPointMake(offsetX, -self.collectionView.contentInset.top) animated:animated];
    }
    
}

- (BOOL)canScrollToToday
{
    if (self.mealplan == nil) return NO;
    
    NSInteger weekday = [self currentWeekday];
    return weekday >= 0 && weekday < 5;
}

- (void)showNoMensaPlaceholder
{
    [self showPlaceholderWithText:NSLocalizedString(@"select a mensa first", nil)];
}

- (void)showOfflinePlaceholder
{
    [self showPlaceholderWithText:NSLocalizedString(@"no connection to backend", nil)];
}

- (void)showErrorPlaceholder
{
    [self showPlaceholderWithText:NSLocalizedString(@"data could not be loaded", nil)];
}

- (void)showPlaceholderWithText:(NSString *)text
{
    if (self.placeholderView != nil) return;
    
    UILabel *placeholderLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20.f, 20.f)];
    placeholderLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.textColor = [UIColor blackColor];
    placeholderLabel.font = [UIFont systemFontOfSize:16.f];
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    
    placeholderLabel.text = text;
    
    [self.view addSubview:placeholderLabel];
    self.placeholderView = placeholderLabel;
}

- (void)hidePlaceholder
{
    if (self.placeholderView == nil) return;
    
    [self.placeholderView removeFromSuperview];
    self.placeholderView = nil;
}

- (void)onDismiss:(id)sender
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)onContentSizeCategoryDidChange:(NSNotification *)notification
{
    [self.collectionView reloadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(UIAccessibilityIsVoiceOverRunning()) {
        NSString *text = [self accessibilityTextForPage:[self pageForScrollview:scrollView]];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, text);
    }
}

- (NSInteger)pageForScrollview:(UIScrollView *)scrollView
{
    return lroundf(scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds));
}

- (NSInteger)verticalPagePageNumberForScrollview:(UIScrollView *)scrollView
{
    CGFloat pageHeight = CGRectGetHeight(scrollView.bounds);
    float page = scrollView.contentOffset.y / pageHeight;
    return lround(page);
}

- (NSString *)accessibilityScrollStatusForScrollView:(UIScrollView *)scrollView
{
    NSString *text = nil;
    
    NSInteger previousPage = 0;
    NSInteger page = [self pageForScrollview:scrollView];
    if (page != previousPage) {
        text = [self accessibilityTextForPage:page];
        previousPage = page;
    }
    
    return text;
}

- (NSString *)accessibilityTextForPage:(NSInteger)page
{
    NSInteger day = page;
    KPBMenu *menu = _mealplan.menus[day];
    
    NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
    
    dateFormatter.dateFormat = @"cccc";
    
    NSString *weekdayText = [dateFormatter stringFromDate:menu.date];
    
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    NSString *dateText = [dateFormatter stringFromDate:menu.date];
    
    return [NSString stringWithFormat:@"%@ %@", weekdayText, dateText];
}

@end

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

@interface KPBMealplanViewController () <KPBMealplanLayoutDelegate>

@property (nonatomic) KPBMealplan *mealplan;
@property (nonatomic) NSDateFormatter *menuHeaderDateFormatter;
@property (nonatomic, weak) UIView *placeholderView;

@end

@implementation KPBMealplanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[KPBMealCell class] forCellWithReuseIdentifier:KPBMealplanViewControllerMealCellIdentifier];
    [self.collectionView registerClass:[KPBMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KPBMealplanViewControllerMenuHeaderViewIdentifier];
    [self.collectionView registerClass:[KPBMealplanInfoView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:KPBMealplanViewControllerInfoViewIdentifier];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self scrollToTodayAnimated:NO];
    
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
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    progressHud.labelText = @"Speiseplan wird geladen";
    
    [self.mensa currentMealplanWithSuccess:^(KPBMensa *mensa, KPBMealplan *mealplan) {
        [progressHud hide:YES];
        
        if (mealplan == nil) {
            [self showErrorPlaceholder];
        } else {
            [self onLoadedMealplan:mealplan];
        }
        
    } failure:^(KPBMensa *mensa, NSError *error) {
        
        [progressHud hide:YES];
        NSLog(@"failed to get mealplan data: %@", error);
        [self showErrorPlaceholder];
        
    }];
    
}

- (void)onLoadedMealplan:(KPBMealplan *)mealplan
{
    
    self.mealplan = mealplan;
    [self hidePlaceholder];
    [self.collectionView reloadData];
    
    if ([self canScrollToToday]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Heute"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self action:@selector(onScrollToToday:)];
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
        
        dateFormatter.dateFormat = @"'Daten geladen am' dd.MM.YYYY 'um' HH:MM 'Uhr'";
        
        infoView.textLabel.text = [dateFormatter stringFromDate:self.mealplan.fetchDate];
        
        return infoView;
    } else if ([UICollectionElementKindSectionHeader isEqualToString:kind]) {
        KPBMenuHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:KPBMealplanViewControllerMenuHeaderViewIdentifier forIndexPath:indexPath];
        
        NSDateFormatter *dateFormatter = self.menuHeaderDateFormatter;
        
        NSInteger day = indexPath.item % 5;
        
        KPBMenu *menu = self.mealplan.menus[day];
        
        dateFormatter.dateFormat = @"cccc";
        
        headerView.dayLabel.text = [dateFormatter stringFromDate:menu.date];
        
        dateFormatter.dateFormat = @"dd.MM.YYYY";
        
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
    
    if (self.mealplan == nil) CGSizeMake(width, 80.f);
    
    NSInteger day = indexPath.item % 5;
    
    KPBMenu *menu = self.mealplan.menus[day];
    
    NSInteger mealIndex = indexPath.item / 5;
    
    KPBMeal *meal = menu.meals[mealIndex];
    
    CGFloat height = [KPBMealCell heightForWidth:width title:meal.title text:meal.text priceText:meal.priceText andInfoText:meal.infoText];
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionReusableView *)collectionView layout:(UICollectionViewLayout *)layout widthForColumn:(NSInteger)column forSectionAtIndex:(NSInteger)section
{
    return 200.f;
}

- (NSInteger)collectionView:(UICollectionReusableView *)collectionView layout:(UICollectionViewLayout *)layout columnIndexForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row % 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForHeaderWithWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, 50.f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout insetsForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return UIEdgeInsetsZero;
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

- (NSInteger)currentWeekday
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"DE_de"];
    
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
        
        [self.collectionView setContentOffset:CGPointMake(offsetX, -64.f) animated:animated];
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
    [self showPlaceholderWithText:@"Bitte wähle zunächst eine Mensa aus"];
}

- (void)showOfflinePlaceholder
{
    [self showPlaceholderWithText:@"Es besteht derzeit keine Verbindung zum Internet!"];
}

- (void)showErrorPlaceholder
{
    [self showPlaceholderWithText:@"Der Speiseplan konnte nicht geladen werden. Bitte probiere es später erneut! \n Manchmal dauert es am Montag leider ein wenig bis die Daten bereit stehen... :(  "];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KPBMensaDetailViewController *mensaDetailViewController = segue.destinationViewController;
    mensaDetailViewController.mensa = _mensa;
}

@end

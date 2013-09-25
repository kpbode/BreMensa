#import "KPBMensaMenuViewController.h"
#import "KPBMensa.h"
#import "KPBMealplanSegue.h"
#import "KPBMealplanViewController.h"
#import "KPBMensaDetailViewController.h"

@interface KPBMensaMenuViewController () <KPBMealplanSegueDelegate>

@property (nonatomic, weak) UIImageView *containerView;
@property (nonatomic, copy) NSArray *mensas;
@property (nonatomic) KPBMensa *lastSelectedMensa;
@property (nonatomic) BOOL shouldPresentLastMensaImmediatly;

@end

@implementation KPBMensaMenuViewController

static NSString * const KPBMensaMenuViewControllerLastScreenshotRestorationKey = @"lastScreenshot";
static NSString * const KPBMensaMenuViewControllerLastSelectedMensaRestorationKey = @"lastSelectedMensa";
static NSString * const KPBMensaMenuViewControllerPresentingMensaRestorationKey = @"presentingMensa";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mensas = [KPBMensa availableMensaObjects];
    
    CGRect containerFrame = self.view.bounds;
    
    UIImageView *containerView = [[UIImageView alloc] initWithFrame:containerFrame];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapContainerViewGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapContainerView:)];
    [containerView addGestureRecognizer:tapContainerViewGestureRecognizer];
    
    [self.view addSubview:containerView];
    self.containerView = containerView;
    

    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeScale(.6f, .6f);
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(170.f, 0.f));
    
    containerView.transform = transform;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_shouldPresentLastMensaImmediatly) {
        
        [self performSegueWithIdentifier:@"ShowMealplanSegue" sender:self];
        
        self.shouldPresentLastMensaImmediatly = NO;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mensas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MensaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    KPBMensa *mensa = [self mensaAtIndexPath:indexPath];
    
    cell.textLabel.text = mensa.name;
    
    return cell;
}

- (KPBMensa *)mensaAtIndexPath:(NSIndexPath *)indexPath
{
    return _mensas[indexPath.row];
}

- (KPBMensa *)mensaForServerId:(NSString *)serverId
{
    for (KPBMensa *mensa in _mensas) {
        if ([serverId isEqualToString:mensa.serverId]) return mensa;
    }
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[KPBMealplanSegue class]]) {
        KPBMealplanSegue *mealplanSegue = (KPBMealplanSegue *) segue;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        KPBMensa *mensa = [self mensaAtIndexPath:indexPath];
        if (indexPath == nil) {
            mensa = _lastSelectedMensa;
        }
        
        UINavigationController *navigationController = (UINavigationController *) mealplanSegue.destinationViewController;
        KPBMealplanViewController *mealplanViewController = (KPBMealplanViewController *) navigationController.topViewController;
        mealplanViewController.mensa = mensa;
        
        mealplanSegue.targetFrame = self.view.frame;
        mealplanSegue.shownTransform = CGAffineTransformIdentity;
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeScale(.6f, .6f);
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(170.f, 0.f));
        
        mealplanSegue.hiddenTransform = _containerView.transform;
        mealplanSegue.delegate = self;
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.lastSelectedMensa = mensa;
    } else if ([segue.identifier isEqualToString:@"ShowSettingsSegue"]) {
        
        UINavigationController *navigationController = segue.destinationViewController;
        UIViewController *settingsViewController = navigationController.topViewController;
        settingsViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                                target:self
                                                                                                                action:@selector(onDone:)];
        
    } else if ([segue.identifier isEqualToString:@"ShowMensaDetails"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        KPBMensa *mensa = [self mensaAtIndexPath:indexPath];
        
        UINavigationController *navigationController = segue.destinationViewController;
        KPBMensaDetailViewController *mensaDetailViewController = (KPBMensaDetailViewController *) navigationController.topViewController;
        mensaDetailViewController.mensa = mensa;
        mensaDetailViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                                   target:self
                                                                                                                   action:@selector(onDone:)];
        
    }
}

- (void)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTapContainerView:(id)sender
{
    if (_lastSelectedMensa == nil) return;
    
    [self performSegueWithIdentifier:@"ShowMealplanSegue" sender:self];    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark KPBMealplanSegueDelegate

- (void)mealplanSegue:(KPBMealplanSegue *)mealplanSegue screenshotTakenBeforeDismiss:(UIImage *)screenshot
{
    _containerView.image = screenshot;
}

#pragma mark State Restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    NSData *lastScreenShotData = nil;
    if (_containerView.image != nil) {
        lastScreenShotData = UIImagePNGRepresentation(_containerView.image);
    }
    
    [coder encodeObject:lastScreenShotData forKey:KPBMensaMenuViewControllerLastScreenshotRestorationKey];
    [coder encodeObject:_lastSelectedMensa.serverId forKey:KPBMensaMenuViewControllerLastSelectedMensaRestorationKey];
    
    UINavigationController *navigationController = (UINavigationController *) self.presentedViewController;
    BOOL presentingMealplan = [navigationController.topViewController isKindOfClass:[KPBMealplanViewController class]];
    [coder encodeBool:presentingMealplan forKey:KPBMensaMenuViewControllerPresentingMensaRestorationKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    NSData *lastScreenShotData = [coder decodeObjectForKey:KPBMensaMenuViewControllerLastScreenshotRestorationKey];
    NSString *lastSelectedMensaId = [coder decodeObjectForKey:KPBMensaMenuViewControllerLastSelectedMensaRestorationKey];
    
    self.lastSelectedMensa = [self mensaForServerId:lastSelectedMensaId];
    
    if (lastScreenShotData != nil) {
        _containerView.image = [UIImage imageWithData:lastScreenShotData];
    }
    
    self.shouldPresentLastMensaImmediatly = [coder decodeBoolForKey:KPBMensaMenuViewControllerPresentingMensaRestorationKey];
}

@end

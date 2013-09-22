#import "KPBMensaMenuViewController.h"
#import "KPBMensa.h"
#import "KPBMealplanSegue.h"
#import "KPBMealplanViewController.h"

@interface KPBMensaMenuViewController () <KPBMealplanSegueDelegate>

@property (nonatomic, weak) UIImageView *containerView;

@end

@implementation KPBMensaMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect containerFrame = self.view.bounds;
    
    UIImageView *containerView = [[UIImageView alloc] initWithFrame:containerFrame];
    [self.view addSubview:containerView];
    self.containerView = containerView;

    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeScale(.6f, .6f);
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(170.f, 0.f));
    
    containerView.transform = transform;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[KPBMensa availableMensaObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MensaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    KPBMensa *mensa = [self mensaObjectAtIndexPath:indexPath];
    
    cell.textLabel.text = mensa.name;
    
    return cell;
}

- (KPBMensa *)mensaObjectAtIndexPath:(NSIndexPath *)indexPath
{
    return [KPBMensa availableMensaObjects][indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[KPBMealplanSegue class]]) {
        
        
        
        KPBMealplanSegue *mealplanSegue = (KPBMealplanSegue *) segue;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        KPBMensa *mensa = [self mensaObjectAtIndexPath:indexPath];
        
        NSLog(@"about to show mealplan: %@", mensa.name);
        
        UINavigationController *navigationController = (UINavigationController *) mealplanSegue.destinationViewController;
        KPBMealplanViewController *mealplanViewController = (KPBMealplanViewController *) navigationController.topViewController;
        mealplanViewController.mensa = mensa;
        
        mealplanSegue.targetFrame = self.view.bounds;
        mealplanSegue.shownTransform = CGAffineTransformIdentity;
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeScale(.6f, .6f);
        transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(170.f, 0.f));
        
        mealplanSegue.hiddenTransform = _containerView.transform;
        mealplanSegue.delegate = self;
    }
}

#pragma mark KPBMealplanSegueDelegate

- (void)mealplanSegue:(KPBMealplanSegue *)mealplanSegue screenshotTakenBeforeDismiss:(UIImage *)screenshot
{
    _containerView.image = screenshot;
}

@end

//
//  KPBPickMensaViewController.m
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBPickMensaViewController.h"
#import "KPBMensaDataManager.h"
#import "KPBMealplanViewController.h"
#import "KPBMensaDetailViewController.h"
#import "KPBMoreInfoViewController.h"
#import "KPBDetailDisclosureButton.h"
#import "KPBNavigationManager.h"

@interface KPBPickMensaViewController ()

@property (nonatomic, weak, readwrite) UIButton *moreInfoButton;
@property (nonatomic, copy, readwrite) NSArray *mensas;

@end

@implementation KPBPickMensaViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        if (IS_IPHONE) {
            self.title = @"Hauptmenü";
        }
        
        self.mensas = [KPBMensaDataManager sharedManager].mensas;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.tableView.backgroundView = nil;
    self.tableView.scrollEnabled = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 0.f, 0.f);
    
    UIButton *moreInfoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    moreInfoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    moreInfoButton.center = CGPointMake(CGRectGetWidth(self.tableView.bounds) - 20.f, CGRectGetHeight(self.tableView.bounds) - 40.f);
    [moreInfoButton addTarget:self action:@selector(onShowMoreInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:moreInfoButton];
    self.moreInfoButton = moreInfoButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mensas count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Mensen";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    
    if (title == nil) return nil;
    
    CGRect headerFrame = CGRectMake(0.f, 0.f, CGRectGetWidth(tableView.bounds), [self tableView:tableView heightForHeaderInSection:section]);
    
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerFrame, 15.f, 0.f)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.f];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = nil;
    
    static NSString *CellIdentifier = @"MensaCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (IS_IPHONE) {
            KPBDetailDisclosureButton *detailDisclosureButton = [[KPBDetailDisclosureButton alloc] initWithFrame:CGRectMake(267.f, 0.f, 43.f, 43.f)];
            [detailDisclosureButton addTarget:self action:@selector(onDetailDisclosureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = detailDisclosureButton;
        }
        
    }

    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    KPBMensa *mensa = [self.mensas objectAtIndex:indexPath.row];
    cell.textLabel.text = mensa.name;
}

- (void)onDetailDisclosureButtonPressed:(id)sender
{
    UIButton *button = (UIButton *) sender;
    
    UITableViewCell *cell = (UITableViewCell *) button.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KPBMensa *mensa = [self.mensas objectAtIndex:indexPath.row];
        
    [[KPBNavigationManager sharedManager] showMealplanForMensa:mensa];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    KPBMensa *mensa = [self.mensas objectAtIndex:indexPath.row];
    KPBMensaDetailViewController *detailViewController = [[KPBMensaDetailViewController alloc] initWithMensa:mensa];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)onShowMoreInfo:(id)sender
{
    [[KPBNavigationManager sharedManager] showMoreInfo];
}

@end

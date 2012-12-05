//
//  KPBMensaDetailViewController.m
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMensaDetailViewController.h"
#import "KPBMensaDetailView.h"
#import "KPBMensaLocationMarker.h"

@interface KPBMensaDetailViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic, strong, readwrite) KPBMensa *mensa;
@property (nonatomic, weak, readwrite) KPBMensaDetailView *mensaView;
@property (nonatomic, weak, readwrite) MKMapView *mapView;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation KPBMensaDetailViewController

- (id)initWithMensa:(KPBMensa *)mensa
{
    self = [super init];
    if (self) {
        self.mensa = mensa;
        self.title = mensa.name;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    KPBMensaDetailView *detailView = [[KPBMensaDetailView alloc] initWithFrame:CGRectZero];
    
    detailView.tableView.dataSource = self;
    detailView.tableView.delegate = self;
    detailView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    detailView.tableView.backgroundColor = [UIColor clearColor];
    detailView.tableView.backgroundView = nil;
    
    self.mapView = detailView.mapView;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.view = detailView;
    self.mensaView = detailView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //53.05517, 8.78330
    
    
    
    KPBMensaLocationMarker *locationMarker = [[KPBMensaLocationMarker alloc] initWithMensa:self.mensa];
    [self.mapView addAnnotation:locationMarker];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D zoomLocation = self.mensa.location.coordinate;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 700.0, 700.0);
    [self.mapView setRegion:viewRegion animated:YES];
    
    [self.mensaView.tableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.mensa.openingInfos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    KPBMensaOpeningInfo *info = self.mensa.openingInfos[section];
    return [info.times count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OpenTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.f];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.f];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    KPBMensaOpeningInfo *info = self.mensa.openingInfos[section];
    
    if (info.subtitle != nil && [info.subtitle length] > 0) {
        return [NSString stringWithFormat:@"%@ (%@)", info.title, info.subtitle];
    }
    
    return info.title;
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
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.f];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.shadowColor = [UIColor whiteColor];
    titleLabel.shadowOffset = CGSizeMake(0.f, 1.f);
    
    [headerView addSubview:titleLabel];
    
    return headerView;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    KPBMensaOpeningInfo *info = self.mensa.openingInfos[indexPath.section];
    KPBMensaOpeningTime *time = info.times[indexPath.row];
    
    cell.textLabel.text = time.label;
    cell.detailTextLabel.text = time.value;
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *AnnotationIdentifier = @"MensaLocationAnnotation";
    if ([annotation isKindOfClass:[KPBMensaLocationMarker class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.draggable = NO;
        annotationView.canShowCallout = YES;
        
        return annotationView;
    }
    
    return nil;    
}

@end

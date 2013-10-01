#import "KPBMensaDetailViewController.h"
#import "KPBMensa.h"
#import "KPBMensaLocationMarker.h"
#import "KPBMensaOpeningInfo.h"
#import "KPBMensaOpeningTime.h"

@interface KPBMensaDetailViewController ()

@end

@implementation KPBMensaDetailViewController

- (void)setMensa:(KPBMensa *)mensa
{
    _mensa = mensa;
    self.title = mensa.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self.tableView flashScrollIndicators];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    KPBMensaOpeningInfo *info = self.mensa.openingInfos[section];
    
    if (info.subtitle != nil && [info.subtitle length] > 0) {
        return [NSString stringWithFormat:@"%@ (%@)", NSLocalizedString(info.title, nil), NSLocalizedString(info.subtitle, nil)];
    }
    
    return NSLocalizedString(info.title, nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    KPBMensaOpeningInfo *info = self.mensa.openingInfos[indexPath.section];
    KPBMensaOpeningTime *time = info.times[indexPath.row];
    
    cell.textLabel.text = NSLocalizedString(time.label, nil);
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

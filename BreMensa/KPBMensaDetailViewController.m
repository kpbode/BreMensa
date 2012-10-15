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
    
    self.mapView = detailView.mapView;
    self.mapView.delegate = self;
    
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
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 53.05517;
    zoomLocation.longitude= 8.78330;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1000.0, 1000.0);
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OpenTimeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
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

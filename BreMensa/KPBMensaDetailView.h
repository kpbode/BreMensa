//
//  KPBMensaDetailView.h
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface KPBMensaDetailView : UIView

@property (nonatomic, weak, readonly) MKMapView *mapView;
@property (nonatomic, weak, readonly) UITableView *tableView;

@end

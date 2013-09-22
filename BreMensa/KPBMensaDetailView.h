#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface KPBMensaDetailView : UIView

@property (nonatomic, weak, readonly) MKMapView *mapView;
@property (nonatomic, weak, readonly) UITableView *tableView;

@end

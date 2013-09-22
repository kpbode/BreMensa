#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class KPBMensa;

@interface KPBMensaDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic) KPBMensa *mensa;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@end

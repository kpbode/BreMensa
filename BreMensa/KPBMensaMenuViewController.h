#import <UIKit/UIKit.h>

@interface KPBMensaMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *dismissedContainerView;

@end

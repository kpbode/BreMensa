#import <UIKit/UIKit.h>

@class KPBMensa;

@interface KPBMealplanViewController : UICollectionViewController

@property (nonatomic) KPBMensa *mensa;

- (IBAction)onDismiss:(id)sender;

@end

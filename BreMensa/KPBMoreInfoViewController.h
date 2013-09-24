#import <UIKit/UIKit.h>

@interface KPBMoreInfoViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

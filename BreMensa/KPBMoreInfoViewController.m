#import "KPBMoreInfoViewController.h"
#import <MessageUI/MessageUI.h>

@interface KPBMoreInfoViewController () <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) UIWebView *webView;

@end

@implementation KPBMoreInfoViewController

- (void)loadView
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.autoresizesSubviews = YES;
    containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.dataDetectorTypes = UIDataDetectorTypeLink;
    webView.delegate = self;
    
    // remove shadows
    for (UIView *subview in webView.scrollView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            subview.hidden = YES;
        }
    }
    
    [containerView addSubview:webView];
    self.webView = webView;
    self.view = containerView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Info";
    
    
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                               target:self action:@selector(onShareAppWithFriends:)];
    
    
    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:@"info" withExtension:@"html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:infoFileURL]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)onShareAppWithFriends:(id)sender
{

    NSString *text = @"Hast du BreMensa schon gesehen?";
    NSURL *url = [NSURL URLWithString:@"http://bremensa.hotcoffeeapps.com"];
    
    NSArray *activityItems = @[ text, url ];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.title = @"BreMensa teilen";
    activityViewController.excludedActivityTypes = @[ UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll ];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] hasPrefix:@"mailto:"]) {
        
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:@[@"kpbode@me.com"]];
        [mailComposeViewController setSubject:@"BreMensa-Feedback"];
        
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *message = [NSString stringWithFormat:@"\n\n --- BreMensa %@ [%@] -- %@, iOS %@ (%@)", [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [bundle objectForInfoDictionaryKey:@"CFBundleVersion"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [bundle preferredLocalizations][0]];
        
        
        [mailComposeViewController setMessageBody:message isHTML:NO];
        
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

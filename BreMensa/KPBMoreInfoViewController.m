#import "KPBMoreInfoViewController.h"
#import <MessageUI/MessageUI.h>

@interface KPBMoreInfoViewController () <MFMailComposeViewControllerDelegate, UITextViewDelegate, SKStoreProductViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation KPBMoreInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Info";

    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:@"info" withExtension:@"html"];
    
    NSError *error;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithFileURL:infoFileURL
                                                                             options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType }
                                                                  documentAttributes:nil
                                                                               error:&error];
    NSAssert(attributedText != nil, @"failed to load attributedText from html: %@", error);
    _textView.attributedText = attributedText;
}

- (IBAction)onDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFeedbackMail
{
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setToRecipients:@[@"mail@kpbo.de"]];
    [mailComposeViewController setSubject:@"BreMensa-Feedback"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *message = [NSString stringWithFormat:@"\n\n --- BreMensa %@ [%@] -- %@, iOS %@ (%@)", [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [bundle objectForInfoDictionaryKey:@"CFBundleVersion"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [bundle preferredLocalizations][0]];
    
    
    [mailComposeViewController setMessageBody:message isHTML:NO];
    
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

- (void)shareAppWithFriends
{

    NSString *text = NSLocalizedString(@"Did you know BreMensa?", nil);;
    NSURL *url = [NSURL URLWithString:@"http://bremensa.github.com"];
    
    NSArray *activityItems = @[ text, url ];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.title = NSLocalizedString(@"Share BreMensa", nil);
    activityViewController.excludedActivityTypes = @[ UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll ];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];
}

- (void)rateAppInStore
{
    // 394396552
    
    MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    progressHud.mode = MBProgressHUDModeIndeterminate;
    
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
    productViewController.delegate = self;
    NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : @"394396552" };
    [productViewController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
        [progressHud hide:YES];
        [self presentViewController:productViewController animated:YES completion:nil];
    }];
}

#pragma mark SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.absoluteString hasPrefix:@"sendfeedbackmail"]) {
        
        [self sendFeedbackMail];
    
    } else if ([URL.absoluteString hasPrefix:@"share:"]) {
      
        [self shareAppWithFriends];
        
    } else if ([URL.absoluteString hasPrefix:@"rate"]) {
        
        [self rateAppInStore];
        
    } else {
        [[UIApplication sharedApplication] openURL:URL];
        return YES;
    }
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

@end

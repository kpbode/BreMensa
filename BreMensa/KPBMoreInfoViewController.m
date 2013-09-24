#import "KPBMoreInfoViewController.h"
#import <MessageUI/MessageUI.h>

@interface KPBMoreInfoViewController () <MFMailComposeViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation KPBMoreInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Info";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                           target:self action:@selector(onShareAppWithFriends:)];
    
    
    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:@"info" withExtension:@"html"];
    
//    [self.webView loadRequest:[NSURLRequest requestWithURL:infoFileURL]];
    
    
    NSError *error;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithFileURL:infoFileURL options:@{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType } documentAttributes:NULL error:&error];
    if (attributedString == nil) {
        NSLog(@"error: %@", error);
    } else {
        _textView.attributedText = attributedString;
    }
}

- (IBAction)onDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onShareAppWithFriends:(id)sender
{

    NSString *text = @"Kennst du schon BreMensa?";
    NSURL *url = [NSURL URLWithString:@"http://kpbo.de/BreMensa"];
    
    NSArray *activityItems = @[ text, url ];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.title = @"BreMensa teilen";
    activityViewController.excludedActivityTypes = @[ UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll ];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] hasPrefix:@"mailto:"]) {
        
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:@[@"mail@kpbo.de"]];
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

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([URL.absoluteString hasPrefix:@"mailto:"]) {
        
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        [mailComposeViewController setToRecipients:@[@"mail@kpbo.de"]];
        [mailComposeViewController setSubject:@"BreMensa-Feedback"];
        
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *message = [NSString stringWithFormat:@"\n\n --- BreMensa %@ [%@] -- %@, iOS %@ (%@)", [bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [bundle objectForInfoDictionaryKey:@"CFBundleVersion"], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [bundle preferredLocalizations][0]];
        
        
        [mailComposeViewController setMessageBody:message isHTML:NO];
        
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
        
    } else {
        [[UIApplication sharedApplication] openURL:URL];
    }
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    return YES;
}

@end

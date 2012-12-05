//
//  KPBMoreInfoViewController.m
//  BreMensa
//
//  Created by Karl Bode on 15.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import "KPBMoreInfoViewController.h"

@interface KPBMoreInfoViewController ()

@property (nonatomic, weak, readwrite) UIWebView *webView;

@end

@implementation KPBMoreInfoViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.autoresizesSubviews = YES;
    containerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onShareAppWithFriends:)]; 
    
    NSURL *infoFileURL = [[NSBundle mainBundle] URLForResource:@"info" withExtension:@"html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:infoFileURL]];
    
    /*
    self.textView.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
    self.textView.text = @"BreMensa ist keine offizielle App des Studentenwerk Bremen. \n" \
                        "BreMensa ist ein privates Projekt von Karl Bode und Matthias Friedrich";
     */
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end

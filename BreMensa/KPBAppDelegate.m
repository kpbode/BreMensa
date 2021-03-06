#import "KPBAppDelegate.h"
#import "KPBMensa.h"
#import <HockeySDK/HockeySDK.h>

#if TAKING_SCREENSHOTS

#import <SDScreenshotCapture/SDScreenshotCapture.h>

#endif

@interface KPBAppDelegate () <BITHockeyManagerDelegate, BITCrashManagerDelegate>

@end

@implementation KPBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:[KPBAppConfig hockeyAppApiKey] delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
    
    self.window.tintColor = [UIColor colorWithRed:1.000 green:0.231 blue:0.188 alpha:1];
    
    [KPBAppConfig prepareDefaults];

#if TAKING_SCREENSHOTS
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    tapGesture.numberOfTouchesRequired = 5;
    [self.window addGestureRecognizer:tapGesture];

#endif
    
    return YES;
}

#if TAKING_SCREENSHOTS
    
- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGesture
{
    NSString *screenshotDirectoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"uiautomation_screens"];
    
    NSString *preferredLanguage = [[NSLocale preferredLanguages] firstObject];
    NSString *device = @"3.5inch";
    if (CGRectGetHeight(tapGesture.view.bounds) == 568.f) {
        device = @"4inch";
    }
    
    screenshotDirectoryPath = [screenshotDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@", preferredLanguage, device]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:screenshotDirectoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:screenshotDirectoryPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil error:NULL];
    }
    
    [SDScreenshotCapture takeScreenshotToDirectoryAtPath:screenshotDirectoryPath];
}

#endif

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

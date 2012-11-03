//
//  main.m
//  BreMensa
//
//  Created by Karl Bode on 13.10.12.
//  Copyright (c) 2012 Karl Bode. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KPBAppDelegate.h"

int main(int argc, char *argv[])
{

//    NSString *languageIdentifier = @"en";
//    NSString *countryIdentifier = @"EN";
//
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:languageIdentifier] forKey:@"AppleLanguages"]; // "en"
//    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:languageIdentifier, nil] forKey:@"NSLanguages"]; // "en", "de"
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@_%@", languageIdentifier, countryIdentifier] forKey:@"AppleLocale"]; // "en_US";
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([KPBAppDelegate class]));
    }
}

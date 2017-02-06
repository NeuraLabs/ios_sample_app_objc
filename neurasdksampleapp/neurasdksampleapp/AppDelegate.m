//
//  AppDelegate.m
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 8/26/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//

#import "AppDelegate.h"
#import <NeuraSDK/NeuraSDK.h>
#import <NeuraSDK/NeuraSDKPushNotification.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NeuraSDK.shared.appUID = @"4c7f11c79bbe1d8c8169079eab5588750abb1dc9b2cda6d7de1de50f563b0a41";
    NeuraSDK.shared.appSecret = @"3e4ec9547fb86cc563f9722a3ccaa9258069462a5dd4486936320aec28398ea7";
    [NeuraSDKPushNotification enableAutomaticPushNotification];
  
    return YES;
}

@end

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
    
    [[NeuraSDK sharedInstance] setAppUID:@"4c7f11c79bbe1d8c8169079eab5588750abb1dc9b2cda6d7de1de50f563b0a41"];
    [[NeuraSDK sharedInstance] setAppSecret:@"3e4ec9547fb86cc563f9722a3ccaa9258069462a5dd4486936320aec28398ea7"];
    [NeuraSDKPushNotification enableAutomaticPushNotification];
  
      // Uncomment this line to disable SDK based UI implementation of permission and services error handling.
    // The errors would be received via NeuraSDKErrorDidReceiveNotification notification only.
    // See NeuraSDK.h for details.
    //[[NeuraSDK sharedInstance] enableFeaturesWithKeys:NEUSDKCustomErrorNotification|NEUSDKDisableSdkLogging];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

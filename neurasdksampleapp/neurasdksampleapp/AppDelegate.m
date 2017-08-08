//
//  AppDelegate.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 8/26/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//

#import "AppDelegate.h"
#import <NeuraSDK/NeuraSDK.h>
#import "PushNotifications.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NeuraSDK.shared.appUID = @"4c7f11c79bbe1d8c8169079eab5588750abb1dc9b2cda6d7de1de50f563b0a41";
    NeuraSDK.shared.appSecret = @"3e4ec9547fb86cc563f9722a3ccaa9258069462a5dd4486936320aec28398ea7";
    [PushNotifications requestPermissionForPushNotifications];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
    [PushNotifications registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@">>> Error with registering for remote notifications: %@", error);
    NSLog(@"Please check that you set everything right for supporting push notifications on iOS dev center");
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if ([NeuraSDKPushNotification handleNeuraPushWithInfo:userInfo fetchCompletionHandler:completionHandler]) {
        // A Neura notification was consumed and handled.
        // The SDK will call the completion handler.
        return;
    }
    
    // Handle your own remote notifications here.
    // . . .
    
    // Don't forget to call the completion handler!
    completionHandler(UIBackgroundFetchResultNoData);
}

@end

//
//  PushNotifications.m
//  neurasdksampleapp
//
//  Created by Neura on 08/08/2017.
//  Copyright © 2017 Neura. All rights reserved.
//
#import "PushNotifications.h"
#import <NeuraSDK/NeuraSDK.h>

#define kStoredDeviceToken @"stored device token"

@implementation PushNotifications

+ (void)requestPermissionForPushNotifications {
    UIApplication *application = [UIApplication sharedApplication];
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}


+ (void)registerDeviceToken:(NSData *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:kStoredDeviceToken];
    [NeuraSDKPushNotification registerDeviceToken:deviceToken];
}

+ (NSData *)storedDeviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kStoredDeviceToken];
}

@end

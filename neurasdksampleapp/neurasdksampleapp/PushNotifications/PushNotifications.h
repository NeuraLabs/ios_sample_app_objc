//
//  PushNotifications.h
//  neurasdksampleapp
//
//  Created by Aviv Wolf on 08/08/2017.
//  Copyright © 2017 Neura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotifications : NSObject

+ (void)requestPermissionForPushNotifications;
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (NSData *)storedDeviceToken;

@end

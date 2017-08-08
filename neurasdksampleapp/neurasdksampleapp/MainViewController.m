//
//  MainViewController.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 9/21/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//
#import <NeuraSDK/NeuraSDK.h>
#import <NeuraSDK/NeuraSDKPushNotification.h>
#import "MainViewController.h"
#import "DeviceOperationsViewController.h"
#import "UIView+AppAddon.h"
#import "PushNotifications.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;
@property (strong, nonatomic) IBOutlet UILabel *neuraStatusLabel;
@property (strong, nonatomic) IBOutlet UIButton *permissionsListButton;
@property (strong, nonatomic) IBOutlet UIButton *NeuraSettingsPanelButton;
@property (strong, nonatomic) IBOutlet UIImageView *neuraSymbolTopmImageView;
@property (strong, nonatomic) IBOutlet UIImageView *neuraSymbolBottomImageView;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)permissionsListPressed:(id)sender;
- (IBAction)DeviceOperationsButtonClick:(id)sender;
- (IBAction)openNeuraSettingsPanelButtonClick:(id)sender;

@end


@implementation MainViewController

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setButtonsRoundCorners];
    [self updateSymbolState];
    [self updateAuthenticationButtonState];
}

#pragma mark - UI setup
- (void)setupUI {
    self.loginButton.layer.borderColor = [UIColor colorWithRed:0.2102 green:0.7655 blue:0.9545 alpha:1.0].CGColor;
    self.loginButton.layer.borderWidth = 1;

    self.sdkVersionLabel.text = [NSString stringWithFormat:@"SDK version: %@", [NeuraSDK.shared getVersion]];
    NSString *appVer = [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.appVersionLabel.text = appVer;
}

- (void)setButtonsRoundCorners {
    for (UIView *sub in self.view.subviews) {
        if ([sub class] == [UIButton class]) {
            [sub roundCorners];
        }
    }
}

//- (void)neuraSDKDidReceiveRemoteNotification:(NSNotification *) notification {
//    
//    NSLog(@"push = %@",notification);
//    
//    // Extract Event Name and Timestamp
//    NSError *error = nil;
//    NSDictionary *data = [notification.userInfo objectForKey:@"data"];
//    if(NSOrderedSame == [[data objectForKey:@"pushType"] compare:@"neura_event" options:NSCaseInsensitiveSearch]){
//        
//        NSString *pushDataString = [data objectForKey:@"pushData"];
//        if(!pushDataString) {
//            NSLog(@"No Neura Push data found!");
//            return;
//        }
//        
//        NSDictionary *pushData = [NSJSONSerialization JSONObjectWithData:[pushDataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
//        if(!error && pushData) {
//            NSDictionary *event = [pushData objectForKey:@"event"];
//            NSString *eventName = [event objectForKey:@"name"];
//            NSString *eventTimestamp = [event objectForKey:@"timestamp"];
//            NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[eventTimestamp doubleValue]];
//            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"HH:mm:ss.SSS dd/MM/yyyy"];
//            NSString *timeDate = [dateFormatter stringFromDate:eventDate];
//            
//            NSLog(@"Received event name:[%@], date:[%@]", eventName, timeDate);
//            
//            UILocalNotification *lc = [[UILocalNotification alloc] init];
//            lc.alertBody = [NSString stringWithFormat:@"Neura Event: [%@]\nTime: [%@]", eventName, timeDate];
//            lc.soundName = UILocalNotificationDefaultSoundName;
//            [[UIApplication sharedApplication] presentLocalNotificationNow:lc];
//            
//        } else {
//            NSLog(@"JSon serialization error:[%@]", [error description]);
//        }
//        
//    } else {
//        NSLog(@"Non-Neura Push message received.");
//    }
//}
//
//
//- (void)neuraSDKErrorNotificationDidReceive:(NSNotification*)notification {
//    NSArray *arrErrors = [[notification userInfo] objectForKey:kNeuraSDKErrorsArrayKey];
//    for (NSError *err in arrErrors) {
//        NSLog(@"NeuraSdk Permission/Service Error was received: [%@]", [err localizedDescription]);
//    }
//}


#pragma mark - UI Updated based on authentication state
- (void)updateSymbolState {
    BOOL isConnected = NeuraSDK.shared.isAuthenticated;
    self.neuraSymbolTopmImageView.alpha = isConnected ? 1.0 : 0.3;
    self.neuraSymbolBottomImageView.alpha = isConnected ? 1.0 : 0.3;
}

- (void)updateAuthenticationButtonState {
    NeuraAuthState authenticationState = NeuraSDK.shared.authenticationState;
    NSString *title;
    switch (authenticationState) {
        case NeuraAuthStateAuthenticatedAnonymously:
            title = @"Disconnect";
            break;
        case NeuraAuthStateAccessTokenRequested:
            title = @"Connecting...";
            break;
        default:
            title = @"Connect to Neura";
    }
    [self.loginButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Buttons state
-(void)updateButtonsState {
    if (NeuraSDK.shared.isAuthenticated) {
        [self.permissionsListButton setTitle:@"Edit Subscriptions" forState:UIControlStateNormal];
    } else {
        [self.permissionsListButton setTitle:@"Permissions List" forState:UIControlStateNormal];
    }
}

#pragma mark - login To Neura
- (void)loginToNeura {
    // Here we will be using the anonymous authentication flow offered by the SDK.
    // The Neura SDK also offers phone number based authentication with user's validation/confirmation.
    // Check the docs for full info about all the available authentication options.

    NSData *deviceToken = [PushNotifications storedDeviceToken];
    if (![deviceToken isKindOfClass:[NSData class]]) {
        // You must have a device token for sending push notifications for anonymous login.
        //
        [self showAlertWithTitle:@"Missing push token" message:@"The user must allow push notifications for anonymous login to work."];
        return;
    }
    
    [self.view addDarkLayerWithAlpha:0.5];
    NeuraAnonymousAuthenticationRequest *request = [[NeuraAnonymousAuthenticationRequest alloc] initWithDeviceToken:deviceToken];
    [NeuraSDK.shared authenticateWithRequest:request callback:^(NeuraAuthenticationResult * _Nonnull result) {
        if (result.error) {
            // Handle authentication errors.
            NSLog(@"login error = %@", result.error);
        }
        [self updateSymbolState];
        [self updateAuthenticationButtonState];
        [self.view removeDarkLayer];
    }];
}

#pragma mark - logout from Neura
- (void)logoutFromNeura {
    if (!NeuraSDK.shared.isAuthenticated) return;
    
    [NeuraSDK.shared logoutWithCallback:^(NeuraLogoutResult * _Nonnull result) {
        [self updateSymbolState];
    }];
}

#pragma mark - User alerts
- (void)showUserNotLoggedInAlert {
    [self showAlertWithTitle:@"The user is not logged in" message:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - User action
- (IBAction)loginButtonPressed:(id)sender {
    if (NeuraSDK.shared.isAuthenticated) {
        [self logoutFromNeura];
    } else {
        [self loginToNeura];
    }
}

- (IBAction)openNeuraSettingsPanelButtonClick:(id)sender {
    if (NeuraSDK.shared.isAuthenticated) {
        [NeuraSDK.shared openNeuraSettingsPanel];
    } else {
        [self showUserNotLoggedInAlert];
    }
}

- (IBAction)DeviceOperationsButtonClick:(id)sender {
    if (NeuraSDK.shared.isAuthenticated) {
        DeviceOperationsViewController *deviceOperationsViewController = [[DeviceOperationsViewController alloc] initWithNibName:@"DeviceOperationsViewController" bundle:nil];
        [self presentViewController:deviceOperationsViewController animated:YES completion:nil];
    } else {
        [self showUserNotLoggedInAlert];
    }
}

- (IBAction)permissionsListPressed:(id)sender {
    if (NeuraSDK.shared.isAuthenticated) {
        [self performSegueWithIdentifier:@"SubscriptionsList" sender:self];
    } else {
        [self performSegueWithIdentifier:@"permissionsList" sender:self];
    }
}

@end

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
#import "UIView+AppAddon.h"
#import "PushNotifications.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkVersionLabel;
@property (strong, nonatomic) IBOutlet UILabel *neuraStatusLabel;

@property (strong, nonatomic) IBOutlet UIImageView *neuraSymbolTopmImageView;
@property (strong, nonatomic) IBOutlet UIImageView *neuraSymbolBottomImageView;

- (IBAction)loginButtonPressed:(id)sender;

@end

@implementation MainViewController

#pragma mark - VC Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI Updated based on authentication state
- (void)updateSymbolState {
    BOOL isConnected = NeuraSDK.shared.isAuthenticated;
    self.neuraSymbolTopmImageView.alpha   = isConnected ? 1.0 : 0.3;
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

#pragma mark - UI updates based on authentication state

- (void)updateAuthenticationLabelState {
    NeuraAuthState authState = NeuraSDK.shared.authenticationState;
    NSString *text;
    UIColor *color;
    switch (authState) {
        case NeuraAuthStateAccessTokenRequested:
            color = [UIColor blueColor];
            text = @"Requested tokens...";
            break;
        case NeuraAuthStateAuthenticated:
        case NeuraAuthStateAuthenticatedAnonymously:
            color = [UIColor colorWithRed:0 green:0.4 blue:0 alpha:1.0];
            text = [NeuraSDK.shared neuraUserId];
            break;
        case NeuraAuthStateFailedReceivingAccessToken:
            color = [UIColor redColor];
            text = @"Failed receiving tokens";
            break;
        default:
            color = [UIColor darkGrayColor];
            text = @"Disconnected";
    }
    self.neuraStatusLabel.text = text;
    self.neuraStatusLabel.textColor = color;
}

#pragma mark - Authentication
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
    NeuraAnonymousAuthenticationRequest *request = [NeuraAnonymousAuthenticationRequest new];
    [NeuraSDK.shared authenticateWithRequest:request callback:^(NeuraAuthenticationResult * _Nonnull result) {
        if (result.error) {
            // Handle authentication errors.
            NSLog(@"login error = %@", result.error);
        }
        [self updateSymbolState];
        [self neuraAuthStateUpdated];
        [self.view removeDarkLayer];
    }];
}

- (void)logoutFromNeura {
    if (!NeuraSDK.shared.isAuthenticated) return;
    
    [NeuraSDK.shared logoutWithCallback:^(NeuraLogoutResult * _Nonnull result) {
        [self updateSymbolState];
        [self neuraAuthStateUpdated];
    }];
}

- (void)neuraAuthStateUpdated {
    [self updateAuthenticationButtonState];
    [self updateAuthenticationLabelState];
}

#pragma mark - User alerts

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UI setup
- (void)setupUI {
    self.loginButton.layer.borderColor = [UIColor colorWithRed:0.2102 green:0.7655 blue:0.9545 alpha:1.0].CGColor;
    self.loginButton.layer.borderWidth = 1;
    
    self.sdkVersionLabel.text = [NSString stringWithFormat:@"SDK version: %@", [NeuraSDK.shared getVersion]];
    NSString *appVer = [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.appVersionLabel.text = appVer;
    
    [self updateSymbolState];
    [self updateAuthenticationButtonState];
    [self updateAuthenticationLabelState];
}

#pragma mark - IB Actions
- (IBAction)loginButtonPressed:(id)sender {
    if (NeuraSDK.shared.isAuthenticated) {
        [self logoutFromNeura];
    } else {
        [self loginToNeura];
    }
}

@end

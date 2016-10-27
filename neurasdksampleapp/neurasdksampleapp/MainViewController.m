//
//  MainViewController.m
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 9/21/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//
#import <NeuraSDK/NeuraSDK.h>
#import <NeuraSDK/NeuraSDKPushNotification.h>
#import "MainViewController.h"
#import "DeviceOperationsViewController.h"
#import "UIView+AppAddon.h"

#define kIsUserLogin @"Is_user_login"

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




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Push token: %@",[NeuraSDKPushNotification getDeviceToken]);
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(neuraSDKDidReceiveRemoteNotification:)
                                                 name:NeuraSDKDidReceiveRemoteNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(neuraSDKErrorNotificationDidReceive:)
                                                 name:NeuraSDKErrorDidReceiveNotification
                                               object:nil];
    

    [self setButtonsRoundCorners];
    self.permissionsListButton.layer.borderColor = [UIColor colorWithRed:0.2102 green:0.7655 blue:0.9545 alpha:1.0].CGColor;
    self.permissionsListButton.layer.borderWidth = 1;
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kIsUserLogin]) {
        [self neuraConnectSymbolAnimate];
    }
    self.sdkVersionLabel.text = [NSString stringWithFormat:@"SDK version: %@", [[NeuraSDK sharedInstance] getVersion]];
    NSString *appVer = [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.appVersionLabel.text = appVer;
}


- (void)neuraSDKDidReceiveRemoteNotification:(NSNotification *) notification {
    
    NSLog(@"push = %@",notification);
    
    // Extract Event Name and Timestamp
    NSError *error = nil;
    NSDictionary *data = [notification.userInfo objectForKey:@"data"];
    if(NSOrderedSame == [[data objectForKey:@"pushType"] compare:@"neura_event" options:NSCaseInsensitiveSearch]){
        
        NSString *pushDataString = [data objectForKey:@"pushData"];
        if(!pushDataString) {
            NSLog(@"No Neura Push data found!");
            return;
        }
        
        NSDictionary *pushData = [NSJSONSerialization JSONObjectWithData:[pushDataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if(!error && pushData) {
            NSDictionary *event = [pushData objectForKey:@"event"];
            NSString *eventName = [event objectForKey:@"name"];
            NSString *eventTimestamp = [event objectForKey:@"timestamp"];
            NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:[eventTimestamp doubleValue]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss.SSS dd/MM/yyyy"];
            NSString *timeDate = [dateFormatter stringFromDate:eventDate];
            
            NSLog(@"Received event name:[%@], date:[%@]", eventName, timeDate);
            
            UILocalNotification *lc = [[UILocalNotification alloc] init];
            lc.alertBody = [NSString stringWithFormat:@"Neura Event: [%@]\nTime: [%@]", eventName, timeDate];
            lc.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] presentLocalNotificationNow:lc];
            
        } else {
            NSLog(@"JSon serialization error:[%@]", [error description]);
        }
        
    } else {
        NSLog(@"Non-Neura Push message received.");
    }
}


- (void)neuraSDKErrorNotificationDidReceive:(NSNotification*)notification {
    NSArray *arrErrors = [[notification userInfo] objectForKey:kNeuraSDKErrorsArrayKey];
    for (NSError *err in arrErrors) {
        NSLog(@"NeuraSdk Permission/Service Error was received: [%@]", [err localizedDescription]);
    }
}

- (void)setButtonsRoundCorners {
    for (UIView *sub in self.view.subviews) {
        if ([sub class] == [UIButton class]) {
            [sub roundCorners];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Neura Symbol Animation
- (void)neuraConnectSymbolAnimate{
    [UIView animateWithDuration:1 animations:^{
        self.neuraSymbolTopmImageView.frame = CGRectMake( self.view.center.x - (self.neuraSymbolTopmImageView.frame.size.width/2), self.neuraSymbolTopmImageView.frame.origin.y, self.neuraSymbolTopmImageView.frame.size.width, self.neuraSymbolTopmImageView.frame.size.height);
        self.neuraSymbolBottomImageView.frame = CGRectMake(self.view.center.x - (self.neuraSymbolTopmImageView.frame.size.width/2), self.neuraSymbolBottomImageView.frame.origin.y, self.neuraSymbolBottomImageView.frame.size.width, self.neuraSymbolBottomImageView.frame.size.height);
        self.neuraSymbolTopmImageView.alpha = 1;
        self.neuraSymbolBottomImageView.alpha = 1;
    } completion:^(BOOL finished) {
        self.neuraStatusLabel.text = @"Connected";
        self.neuraStatusLabel.textColor = [UIColor greenColor];
        [self.loginButton setTitle:@"Disconnect" forState:UIControlStateNormal];
        [self.permissionsListButton setTitle:@"Edit Subscriptions" forState:UIControlStateNormal];
    }];
}


- (void)neuraDisconnecSymbolAnimate{
    [UIView animateWithDuration:1 animations:^{
        self.neuraSymbolTopmImageView.frame = CGRectMake(self.neuraSymbolTopmImageView.frame.origin.x - self.neuraSymbolTopmImageView.frame.size.width/3, self.neuraSymbolTopmImageView.frame.origin.y, self.neuraSymbolTopmImageView.frame.size.width, self.neuraSymbolTopmImageView.frame.size.height);
        self.neuraSymbolBottomImageView.frame = CGRectMake(self.neuraSymbolBottomImageView.frame.origin.x + self.neuraSymbolBottomImageView.frame.size.width/3, self.neuraSymbolBottomImageView.frame.origin.y, self.neuraSymbolBottomImageView.frame.size.width, self.neuraSymbolBottomImageView.frame.size.height);
        self.neuraSymbolTopmImageView.alpha = 0.2;
        self.neuraSymbolBottomImageView.alpha = 0.2;
    } completion:^(BOOL finished) {
        self.neuraStatusLabel.text = @"Disconnected";
        self.neuraStatusLabel.textColor = [UIColor redColor];
        [self.loginButton setTitle:@"Connect and Request Permissions" forState:UIControlStateNormal];
        [self.permissionsListButton setTitle:@"Permissions List" forState:UIControlStateNormal];
    }];
}
#pragma mark - login To Neura
- (void)loginToNeura {
    
    [self.view addDarkLayerWithAlpha:0.5];
    [[NeuraSDK sharedInstance] getAppPermissionsWithHandler:^(NSArray *permissionsArray, NSString *error) {
        
        NSMutableArray *permissions = nil;
        if (!error) {
            permissions = [NSMutableArray new];
            for (NSDictionary* dict in permissionsArray) {
                NSString *event = [dict objectForKey:@"name"];
                if(event) {
                    [permissions addObject:event];
                }
            }
        } else {
            permissions = [NSMutableArray arrayWithObjects:@"userStartedDriving",
                            @"userArrivedToWork",
                            @"userLeftHome",
                            @"userStartedRunning",
                            @"userArrivedHome",
                            @"userStartedWorkOut",
                            @"activitySummaryPerPlace",
                            @"wellnessProfile",
                            @"dailyActivitySummary",
                            @"getPersonNodesSemantics",
                            @"userArrivedWorkFromHome",
                            @"getLocationNodesSemantics",
                            @"sleepData",
                            @"getDeviceNodesSemantics",
                            @"userSituation",
                            @"userFinishedDriving",
                            @"userFinishedRunning",
                            @"userStartedWalking",
                            @"userFinishedWalking",
                            @"userIsOnTheWayToWork",
                            @"userIsOnTheWayToActiveZone",
                            @"userIsOnTheWayHome", 
                            @"userGotUp", 
                            @"userStartedSleeping", 
                            @"userFinishedWorkOut", 
                            @"userLeftWork", 
                            @"userLeftActiveZone", 
                            @"userArrivedHomeFromWork", 
                            @"userArrivedAtGroceryStore", 
                            @"userArrivedAtSchoolCampus", 
                            @"userArrivedAtAirport", 
                            @"userArrivedAtHospital", 
                            @"userArrivedAtClinic", 
                            @"userArrivedAtRestaurant", 
                            @"userArrivedAtCafe",
                            @"userArrivedAtPharmacy", 
                            @"userArrivedAtActiveZone", 
                            @"userArrivedToGym", 
                            @"userLeftAirport", 
                            @"userLeftCafe", 
                            @"userLeftHospital", 
                            @"userLeftRestaurant",
                            @"userLeftSchoolCampus", 
                            @"userLeftGym", nil];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addDarkLayerWithAlpha:0.0];
        });
        
        [[NeuraSDK sharedInstance] authenticateWithPermissions:permissions
                                                  onController:self
                                                   withHandler:^(NSString *token, NSString *error) {
                                                       if (token) {
                                                           NSLog(@"token = %@ ", token);
                                                           [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIsUserLogin];
                                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                                           [self neuraConnectSymbolAnimate];
                                                       }  else {
                                                           NSLog(@"login error = %@", error);
                                                       }
                                                   }];
    }];
    
}


#pragma mark - logout Frome Neura
- (void)logoutFromeNeura {
    [[NeuraSDK sharedInstance] logout];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kIsUserLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self neuraDisconnecSymbolAnimate];
}


#pragma mark - User action
- (IBAction)openNeuraSettingsPanelButtonClick:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserLogin]) {
        [[NeuraSDK sharedInstance] openNeuraSettingsPanel];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The user is not logged in"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (IBAction)DeviceOperationsButtonClick:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserLogin]) {
        
        DeviceOperationsViewController *deviceOperationsViewController = [[DeviceOperationsViewController alloc] initWithNibName:@"DeviceOperationsViewController" bundle:nil];
        [self presentViewController:deviceOperationsViewController animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The user is not logged in"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (IBAction)loginButtonPressed:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIsUserLogin]) {
        [self logoutFromeNeura];
    } else {
        [self loginToNeura];
    }
}


- (IBAction)permissionsListPressed:(id)sender {
    if ([self.permissionsListButton.titleLabel.text isEqualToString:@"Permissions List"]) {
        [self performSegueWithIdentifier:@"permissionsList" sender:self];
    } else {
        [self performSegueWithIdentifier:@"SubscriptionsList" sender:self];
    }
}




@end

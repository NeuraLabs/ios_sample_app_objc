//
//  DeviceOperationsViewController.m
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 29/05/2016.
//  Copyright © 2016 Neura. All rights reserved.
//

#import "StringPicker.h"
#import <NeuraSDK/NeuraSDK.h>
#import "DeviceOperationsViewController.h"
#import "UIView+AppAddon.h"


@interface DeviceOperationsViewController ()

@property (nonatomic, strong) NSString *selectedName;
@property (nonatomic, strong) NSString *selectedCapabiliti;

- (IBAction)backButtonClick:(id)sender;
- (IBAction)addDeviceButtonClick:(id)sender;
- (IBAction)hasCapabilitiButtonClick:(id)sender;
- (IBAction)getSupportedDevicesListButtonClick:(id)sender;
- (IBAction)getSupportedCapabilitiesListButtonClick:(id)sender;

@end

@implementation DeviceOperationsViewController

-(void)viewDidLoad {
    [self setButtonsRoundCorners];
}


#pragma mark - User action
- (IBAction)getSupportedDevicesListButtonClick:(id)sender {
    [self getSupportedDevicesList:sender addMode:NO];
}


- (IBAction)getSupportedCapabilitiesListButtonClick:(id)sender {
    [self getSupportedCapabilities:sender addMode:NO];
}


- (IBAction)addDeviceButtonClick:(id)sender {
    
    self.selectedName = @"";
    self.selectedCapabiliti = @"";
    NSArray *list = @[@"All", @"Name", @"Capability" ];
    
    [StringPicker showPickerWithTitle:@"Add Device by..." buttons:2 rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        
        if (selectedIndex == 0) {
            [self addDeviceWithCapability:nil orDeviceName:nil];
        } else if (selectedIndex == 1) {
            [self getSupportedDevicesList:sender addMode:YES];
        } else if (selectedIndex == 2) {
            [self getSupportedCapabilities:sender addMode:YES];
        }
    }];
}


- (IBAction)hasCapabilitiButtonClick:(id)sender {
    [self.view addDarkLayerWithAlpha:0.5];
    [[NeuraSDK sharedInstance] getSupportedCapabilitiesListWithHandler:^(NSDictionary *responseData, NSString *error) {
        [self.view addDarkLayerWithAlpha:0];
        if (responseData) {
            NSArray *list = [responseData[@"items"] valueForKey:@"name"];
            
            [StringPicker showPickerWithTitle:@"Select capability" buttons:2 rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                [self.view addDarkLayerWithAlpha:0.5];
                [[NeuraSDK sharedInstance]
                 hasDeviceWithCapability:selectedValue
                 withHandler:^(NSDictionary *responseData, NSString *error) {
                     [self.view addDarkLayerWithAlpha:0];
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseData[@"status"]
                                                                     message:nil
                                                                    delegate:self
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                 }];
            }];
        }}];
}


- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)addDeviceWithCapability:(NSString *)capability orDeviceName:(NSString *)deviceName {
    [[NeuraSDK sharedInstance] addDeviceWithCapability:capability
                                          deviceName:deviceName
                                           withHandler:^(NSDictionary *responseData, NSString *error) {
        
                                               NSLog(@"responseData:%@ \n error:%@", responseData, error);
                                               
                                               if (error) {
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                                                   message:error
                                                                                                  delegate:self
                                                                                         cancelButtonTitle:@"Ok"
                                                                                         otherButtonTitles:nil, nil];
                                                   [alert show];
                                               }
                                           }];
}


- (void)getSupportedCapabilities:(id)sender addMode:(BOOL)add {
    [self.view addDarkLayerWithAlpha:0.5];
    [[NeuraSDK sharedInstance] getSupportedCapabilitiesListWithHandler:^(NSDictionary *responseData, NSString *error) {
        [self.view addDarkLayerWithAlpha:0];
        if (responseData) {
            NSArray *list = [responseData[@"items"] valueForKey:@"name"];
            int button = add? 2 : 1;
            [StringPicker showPickerWithTitle:@"Capabilities List" buttons:button rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                if (selectedValue && add) {
                    [self addDeviceWithCapability:selectedValue orDeviceName:nil];
                }
            }];
        }
    }];
}


- (void)getSupportedDevicesList:(id)sender addMode:(BOOL)add {
    [self.view addDarkLayerWithAlpha:0.5];
    [[NeuraSDK sharedInstance] getSupportedDevicesListWithHandler:^(NSDictionary *responseData, NSString *error) {
        [self.view addDarkLayerWithAlpha:0];
        if (responseData) {
            NSArray *list = [responseData[@"devices"] valueForKey:@"name"];
            if(list && list.count > 0) {
                int button = add? 2 : 1;
                [StringPicker showPickerWithTitle:@"Devices List" buttons:button rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                    if (selectedValue && add) {
                        [self addDeviceWithCapability:nil orDeviceName:selectedValue];
                    }
                }];
            }
        }}];
}

- (void)setButtonsRoundCorners {
    for (UIView *sub in self.view.subviews) {
        if ([sub class] == [UIButton class]) {
            [sub roundCorners];
        }
    }
}


@end

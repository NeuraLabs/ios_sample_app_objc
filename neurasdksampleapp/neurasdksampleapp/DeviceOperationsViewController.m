//
//  DeviceOperationsViewController.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 29/05/2016.
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

#pragma mark - Alerts
- (void)showAlertMessage:(NSString *)message title:(NSString *)title {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
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
    NSArray *list = @[@"Name", @"Capability" ];
    
    [StringPicker showPickerWithTitle:@"Add Device by..." buttons:2 rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
        
        if (selectedIndex == 0) {
            [self getSupportedDevicesList:sender addMode:YES];
        } else if (selectedIndex == 1) {
            [self getSupportedCapabilities:sender addMode:YES];
        }
    }];
}


- (IBAction)hasCapabilitiButtonClick:(id)sender {
    [self.view addDarkLayerWithAlpha:0.5];
    
    [NeuraSDK.shared getSupportedCapabilitiesListWithCallback:^(NeuraSupportedCapabilitiesListResult * _Nonnull result) {
        [self.view addDarkLayerWithAlpha:0];
        if (!result.success) return;
        
        NSArray *list = [result.capabilities valueForKey:@"displayName"];
        [StringPicker showPickerWithTitle:@"Select capability" buttons:2 rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
            [self.view addDarkLayerWithAlpha:0.5];
            NCapability *selectedCapability = result.capabilities[selectedIndex];
            [NeuraSDK.shared hasDeviceWithCapability:selectedCapability
                                        withCallback:^(NeuraHasDeviceWithCapabilityResult * _Nonnull result) {
                                            [self.view addDarkLayerWithAlpha:0];
                                            [self showAlertMessage:nil title:result.hasDevice ? @"YES" : @"NO"];
                                        }];
        }];
    }];
}


- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)addDeviceWithCapability:(NSString *)capability orDeviceName:(NSString *)deviceName {
    if (capability) {
        [NeuraSDK.shared addDeviceWithCapabilityNamed:capability withCallback:^(NeuraAddDeviceResult * _Nonnull result) {
            NSString *message = result.errorString;
            NSString *title = result.success ? @"Success" : @"Failed";
            [self showAlertMessage:message title:title];
        }];
    } else if (deviceName) {
        [NeuraSDK.shared addDeviceNamed:deviceName withCallback:^(NeuraAddDeviceResult * _Nonnull result) {
            NSString *message = result.errorString;
            NSString *title = result.success ? @"Success" : @"Failed";
            [self showAlertMessage:message title:title];
        }];
    } else {
        NSLog(@"Can't add device. No capability name or device name provided.");
    }
}


- (void)getSupportedCapabilities:(id)sender addMode:(BOOL)add {
    [self.view addDarkLayerWithAlpha:0.5];
    
    [NeuraSDK.shared getSupportedCapabilitiesListWithCallback:^(NeuraSupportedCapabilitiesListResult * _Nonnull result) {
        [self.view addDarkLayerWithAlpha:0];
        if (!result.success) return;
        NSArray *list = [result.capabilities valueForKey:@"displayName"];
        int button = add? 2 : 1;
        [StringPicker showPickerWithTitle:@"Capabilities List" buttons:button rows:list WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
            if (selectedValue && add) {
                NCapability *capability = result.capabilities[selectedIndex];
                [self addDeviceWithCapability:capability.name orDeviceName:nil];
            }
        }];
    }];
}


- (void)getSupportedDevicesList:(id)sender addMode:(BOOL)add {
    [self.view addDarkLayerWithAlpha:0.5];
    
    [NeuraSDK.shared getSupportedDevicesListWithCallback:^(NeuraSupportedDevicesListResult * _Nonnull result) {
        [self.view addDarkLayerWithAlpha:0];
        if (!result.success && result.devices.count > 0) return;
        NSArray *list = [result.devices valueForKey:@"name"];
        [StringPicker showPickerWithTitle:@"Devices List" buttons:add? 2:1
                                     rows:list
                              WithHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
                                  if (!add || selectedValue == nil) return;
                                  
                                  NDevice *device = result.devices[selectedIndex];
                                  [self addDeviceWithCapability:nil orDeviceName:device.name];
                              }];
    }];
}

- (void)setButtonsRoundCorners {
    for (UIView *sub in self.view.subviews) {
        if ([sub class] == [UIButton class]) {
            [sub roundCorners];
        }
    }
}


@end

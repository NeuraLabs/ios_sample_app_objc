//
//  SubscriptionsListViewController.m
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 9/16/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//

#import "SubscriptionsListViewController.h"
#import "SubscriptionsListTableViewCell.h"
#import <NeuraSDK/NeuraSDK.h>
#import "UIView+AppAddon.h"


@interface SubscriptionsListViewController () <UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *subscriptionsTableView;
@property (strong, nonatomic) NSArray *permissionsArray;
@property (strong, nonatomic) NSArray *subscriptionsArray;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation SubscriptionsListViewController {
    UISwitch *cellSwitch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showActivityIndicator:NO];
    [self.subscriptionsTableView  registerNib:[UINib nibWithNibName:@"SubscriptionsListTableViewCell" bundle: nil] forCellReuseIdentifier:@"Cell"];
    [self reloadAllData];
    
}


- (void)reloadAllData {
    [[NeuraSDK sharedInstance]getSubscriptions:^(NSDictionary *responseData, NSString *error) {
        if (!error) {
            self.subscriptionsArray = responseData[@"items"];
            [[NeuraSDK sharedInstance]getAppPermissionsWithHandler:^(NSArray *permissionsArray, NSString *error) {
                if (!error) {
                    self.permissionsArray = permissionsArray;
                    [self.subscriptionsTableView reloadData];
                }
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.permissionsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscriptionsListTableViewCell *cell = [self.subscriptionsTableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *permissionDictionary = [self.permissionsArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = permissionDictionary[@"displayName"];
    [cell.switchButton addTarget:self action:@selector(subscribeToEventSwitch:) forControlEvents:UIControlEventValueChanged];
    cell.switchButton.on = NO;
    if (self.subscriptionsArray) {
        for (NSDictionary* dict in self.subscriptionsArray) {
            if ([[dict objectForKey:@"eventName"] isEqualToString:permissionDictionary[@"name"]]) {
                cell.switchButton.on = YES;
                break;
            }
        }
    }
    return cell;
}



#pragma mark - User action
- (void)subscribeToEventSwitch:(UISwitch *)subscribeSwitch {
    
    SubscriptionsListTableViewCell *cell = (SubscriptionsListTableViewCell*)subscribeSwitch.superview.superview;
    NSIndexPath *indexPath = [self.subscriptionsTableView indexPathForCell:cell];
    __block NSDictionary *permissionDictionary = [self.permissionsArray objectAtIndex:indexPath.row];
    
    if (subscribeSwitch.isOn) {
        
        if ([[NeuraSDK sharedInstance]isMissingDataForEvent:permissionDictionary[@"name"]]) {
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:NSLocalizedString(@"The place has not been set yet. Create it now?", "The place has not been set yet. Create it now?")
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"Yes") style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           cellSwitch = subscribeSwitch;
                                                           [self showTheMissingDataToEvent:permissionDictionary[@"name"]];
                                                           
                                                       }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"I will wait", @"I will wait") style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [self subscribeToEvent:permissionDictionary[@"name"]];
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            [alert addAction:ok];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            [self subscribeToEvent:permissionDictionary[@"name"]];
        }
    } else{
        [self removeSubscriptionWithIdentifier:[NSString stringWithFormat:@"_%@",permissionDictionary[@"name"]]];
    }
}




-(void)showTheMissingDataToEvent:(NSString *)eventName {
    
    [[NeuraSDK sharedInstance]getMissingDataForEvent:eventName withHandler:^(NSDictionary *responseData, NSString *error) {
        
        if ([responseData[@"status"]isEqualToString:@"success"] && !error) {
            [self subscribeToEvent:eventName];
            
        } else {
            cellSwitch.on = NO;
            cellSwitch = nil;
        }
    }];
    
    
}



- (void)subscribeToEvent:(NSString *)eventName {
    [self showActivityIndicator:YES];
    [[NeuraSDK sharedInstance]subscribeToEvent:eventName identifier:[NSString stringWithFormat:@"_%@",eventName] webHookID:nil state:[NSString stringWithFormat:@"state_%@",eventName] completion:^(NSDictionary *responseData, NSString *error) {
        [self showActivityIndicator:NO];
        NSLog(@" subscribeToEvent = responseData:%@  error:%@",responseData,error);
        [self reloadAllData];
    }];
    
}


- (void)removeSubscriptionWithIdentifier:(NSString *)identifier {
    [self showActivityIndicator:YES];
    [[NeuraSDK sharedInstance]removeSubscriptionWithIdentifier:identifier complete:^(NSDictionary *responseData, NSString *error) {
        [self showActivityIndicator:NO];
        NSLog(@"removeSubscription = responseData:%@  error:%@",responseData,error);
        [self reloadAllData];
    }];
    
}


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)showActivityIndicator:(BOOL)show {

    if (show) {
        [self.view addDarkLayerWithAlpha:0.8];
    } else {
        [self.view addDarkLayerWithAlpha:0];
    }
}


@end

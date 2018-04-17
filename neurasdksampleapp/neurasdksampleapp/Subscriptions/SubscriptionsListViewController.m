//
//  SubscriptionsListViewController.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 9/16/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//

#import "SubscriptionsListViewController.h"
#import "SubscriptionsListTableViewCell.h"
#import <NeuraSDK/NeuraSDK.h>
#import "UIView+AppAddon.h"


@interface SubscriptionsListViewController () <UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *subscriptionsTableView;
@property (strong, nonatomic) NSDictionary<NSString *,NEvent *> *eventsInfoByName;
@property (strong, nonatomic) NSDictionary<NSString *, NSubscription *> *subscriptionsByName;
@property (strong, nonatomic) NSString * selectedEventName;
- (IBAction)backButtonPressed:(id)sender;

@end

@implementation SubscriptionsListViewController {
    UISwitch *cellSwitch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showActivityIndicator:NO];
    [self.subscriptionsTableView registerNib:[UINib nibWithNibName:@"SubscriptionsListTableViewCell" bundle: nil] forCellReuseIdentifier:@"Cell"];
    
    NSMutableDictionary *d = [NSMutableDictionary new];
    for (NSString *name in [self eventNames]) {
        d[name] = @YES;
    }
    
    [self reloadAllData];
}

-(NSArray <NSString *> *)eventNames {
    // Event names copy pasted from the dev site.
    return @[
              @"userArrivedHome",
              @"userArrivedHomeFromWork",
              @"userLeftHome",
              @"userArrivedHomeByWalking",
              @"userArrivedHomeByRunning",
              @"userIsOnTheWayHome",
              @"userIsIdleAtHome",
              @"userStartedWorkOut",
              @"userFinishedRunning",
              @"userFinishedWorkOut",
              @"userLeftGym",
              @"userFinishedWalking",
              @"userArrivedToGym",
              @"userIsIdleFor2Hours",
              @"userStartedWalking",
              @"userIsIdleFor1Hour",
              @"userStartedRunningFromPlace",
              @"userStartedTransitByWalking",
              @"userStartedRunning",
              @"userFinishedTransitByWalking"
             ];
}

- (NSString *)labelForEventName:(NSString *)eventName {
    NSDictionary *labels = @{@"userArrivedHome"        : @"home",
                            @"userArrivedHomeFromWork" : @"home",
                            @"userLeftHome"            : @"home",
                            @"userArrivedHomeByWalking": @"home",
                            @"userArrivedHomeByRunning": @"home",
                            @"userIsOnTheWayHome"      : @"home",
                            @"userIsIdleAtHome"        : @"home",
                            @"userLeftGym"     : @"gym",
                            @"userArrivedToGym": @"gym"};
    return labels[eventName];
}

- (void)reloadAllData {
    // Get info about subscriptions and events by name
    [NeuraSDK.shared getSubscriptionsListWithCallback:^(NeuraSubscriptionsListResult * _Nonnull result) {
        if (result.success) {
            self.subscriptionsByName = result.subscriptionsByName;
            [NeuraSDK.shared getAppPermissionsListWithCallback:^(NeuraPermissionsListResult * _Nonnull result) {
                self.eventsInfoByName = result.eventsByName;
                [self.subscriptionsTableView reloadData];
            }];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsInfoByName ? self.eventNames.count : 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubscriptionsListTableViewCell *cell = [self.subscriptionsTableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSString *eventName = self.eventNames[indexPath.item];
    NEvent *eventInfo = self.eventsInfoByName[eventName];
    
    if (eventInfo) {
        cell.titleLabel.text = [eventInfo.displayName lowercaseString];
        cell.titleLabel.alpha = 1.0;
    } else {
        cell.titleLabel.text = eventName;
        cell.titleLabel.alpha = 0.4;
    }
    cell.switchButton.on = NO;
    cell.switchButton.enabled = NO;
    cell.switchButton.tag = indexPath.item;
   
    
    cell.switchButton.on = NO;
    if (self.subscriptionsByName && self.subscriptionsByName[eventName]) {
        cell.switchButton.on = YES;
    }
    
    return cell;
}



#pragma mark - User action
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









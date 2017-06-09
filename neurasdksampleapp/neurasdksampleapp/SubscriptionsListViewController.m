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
@property (strong, nonatomic) NSDictionary<NSString *,NEvent *> *eventsInfoByName;
@property (strong, nonatomic) NSDictionary<NSString *, NSubscription *> *subscriptionsByName;
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
    cell.switchButton.tag = indexPath.item;
    
    if (cell.switchButton.allTargets.count == 0) {
        [cell.switchButton addTarget:self action:@selector(subscribeToEventSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    
    cell.switchButton.on = NO;
    if (self.subscriptionsByName && self.subscriptionsByName[eventName]) {
        cell.switchButton.on = YES;
    }
    
    return cell;
}



#pragma mark - User action
- (void)subscribeToEventSwitch:(UISwitch *)subscribeSwitch {
    NSInteger index = subscribeSwitch.tag;
    NSString *eventName = self.eventNames[index];
    NEvent *event = self.eventsInfoByName[eventName];
    NSubscription *subscription = self.subscriptionsByName[eventName];
    
    // Subscription toggle.
    if (subscription) {
        // Currently subscribed so we should remove this subscription.
        [self removeSubscription:subscription];
    } else {
        // Currently not subscribed, so we should add a subscription to this event.
        if ([NeuraSDK.shared isMissingDataForEvent:event.name]) {
            // Data is missing for this event.
            [self alertAboutMissingDataForEventNamed:eventName subscribeSwitch:subscribeSwitch];
        } else {
            // No missing data, we can subscribe to the event.
            [self subscribeToEvent:eventName];
        }
    }
}


-(void)alertAboutMissingDataForEventNamed:(NSString *)eventName subscribeSwitch:(UISwitch *)subscribeSwitch {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"The place has not been set yet. Create it now?", "The place has not been set yet. Create it now?")
                                message:nil
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", @"Yes") style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   cellSwitch = subscribeSwitch;
                                                   [self showTheMissingDataToEvent:eventName];
                                                   
                                               }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"I will wait", @"I will wait") style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self subscribeToEvent:eventName];
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showTheMissingDataToEvent:(NSString *)eventName {
    [NeuraSDK.shared getMissingDataForEvent:eventName withCallback:^(NeuraAPIResult * _Nonnull result) {
        if (result.success) {
            [self subscribeToEvent:eventName];
        } else {
            cellSwitch.on = NO;
            cellSwitch = nil;
        }
    }];
}



- (void)subscribeToEvent:(NSString *)eventName {
    [self showActivityIndicator:YES];
    
    // Init a new subscription.
    NSString *webHookId = @"myWebHookIdObjC"; // <== You will need to change this id to the one you defined on the dev site.
    NSubscription *newSubscription = [[NSubscription alloc] initWithEventName:eventName webhookId:webHookId];
    
    // Add the new subscription.
    [NeuraSDK.shared addSubscription:newSubscription callback:^(NeuraAddSubscriptionResult * _Nonnull result) {
        
        if (result.error != nil) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                                     message:[result.error localizedDescription]
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        [self showActivityIndicator:NO];
        NSLog(@"subscribeToEvent = success:%@ error:%@", @(result.success), result.error);
        [self reloadAllData];
    }];
}


- (void)removeSubscription:(NSubscription *)subscription {
    [self showActivityIndicator:YES];
    [NeuraSDK.shared removeSubscription:subscription callback:^(NeuraAPIResult * _Nonnull result) {
        [self showActivityIndicator:NO];
        NSLog(@"removeSubscription. success:%@ error:%@", @(result.success), result.error);
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









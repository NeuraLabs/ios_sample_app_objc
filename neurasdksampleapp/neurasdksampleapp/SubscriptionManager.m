//
//  SubscroptionManager.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 12/02/2018.
//  Copyright © 2018 Neura. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SubscriptionManager.h"
#import <NeuraSDK/NeuraSDK.h>

@implementation SubscriptionManager



- (id)init {
    self = [super init];
    if (self) {
        self.alreadySubscribedToAll = NO;
         self.currentlyWorking = NO;
         self.checkAgainLater = NO;
        
         self.requiredSubscriptions = @[//@"userFinishedRunning",
//                                  @"userFinishedDriving",
//                                  @"userFinishedWalking",
//                                  @"userStartedSleeping",
//                                  @"userStartedDriving",
//                                  @"userStartedWalking",
//                                  @"userStartedRunning",
                                  @"userArrivedToWork",
//                                  @"userArrivedPlace",
                                  @"userArrivedHome",
//                                  @"userLeftPlace",
//                                  @"userLeftWork",
//                                  @"userLeftHome",
//                                  @"userWokeUp",
//                                  @"userGotUp"
                                  ];
    }
    
    return self;
}

- (void)checkSubscriptions {
    __weak SubscriptionManager *wself = self;
  
    if (self.currentlyWorking) {
        self.checkAgainLater = true;
        return;
    }
    self.currentlyWorking = true;
    
    [NeuraSDK.shared getSubscriptionsListWithCallback:^(NeuraSubscriptionsListResult * result){
        
        if (!result.success){
            [self epicFail];
            return;
        }
        
        wself.lastTimeChecked = [NSDate new];
        wself.missingSubscriptions = [NSMutableArray new];
        for (NSString * subscription in  self.requiredSubscriptions) {
            [wself.missingSubscriptions addObject:subscription];
        }
        
        for (NSubscription *item in result.subscriptions){
            NSString *userId = [NeuraSDK.shared neuraUserId];
            NSString * identifier = [NSString stringWithFormat:@"%@%@%@", item.eventName, @"_", userId];
            
            if ([self.requiredSubscriptions containsObject:item.eventName]) {
                if ([item.identifier isEqualToString:identifier]){
                    NSLog(@"%@", [NSString stringWithFormat:@"%@%@", @"Already subscribed to:", item.eventName]);
                    [self.missingSubscriptions removeObject:item.eventName];
                } else {
                    [NeuraSDK.shared removeSubscription:item callback:^(NeuraAPIResult *result){}];
                }
            }
        }
        [wself subscribeToMissingSubscriptions];
    }];
    
}


- (void)subscribeToMissingSubscriptions {
    if (self.missingSubscriptions.count == 0){
        self.currentlyWorking = false;
        return;
    }
    
    NSString *eventName = [self.missingSubscriptions objectAtIndex:0];
    [self.missingSubscriptions removeObject:eventName];
    __weak SubscriptionManager *wself = self;
    NSString *userId = [NeuraSDK.shared neuraUserId];
    NSString * identifier = [NSString stringWithFormat:@"%@%@%@", eventName, @"_", userId];
    NSString *webhookId;
    NSubscription *sub = [[NSubscription alloc] initWithEventName:eventName identifier:identifier webhookId:webhookId method:NSubscriptionMethodPush];
    [NeuraSDK.shared addSubscription:sub callback:^(NeuraAddSubscriptionResult * response){
        if (!response.error){
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", @"Subscribed to:", eventName]);
        } else {
            NSLog(@"%@", [NSString stringWithFormat:@"%@%@", @"Failed subscription to", eventName]);
        }
        [wself subscribeToMissingSubscriptions];
    }];
}

-(void)epicFail {
    self.currentlyWorking = false;
    self.checkAgainLater = false;
}




@end

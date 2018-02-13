//
//  SubscroptionManager.h
//  NeuraSDKSampleApp
//
//  Created by Neura on 12/02/2018.
//  Copyright © 2018 Neura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionManager : NSObject
@property (atomic, strong)NSArray *requiredSubscriptions;
@property (atomic, strong)NSMutableArray * missingSubscriptions;
@property (atomic)BOOL alreadySubscribedToAll;
@property (atomic)BOOL currentlyWorking;
@property (atomic)BOOL checkAgainLater;
@property (atomic, strong) NSDate *lastTimeChecked;
- (void)checkSubscriptions;
@end

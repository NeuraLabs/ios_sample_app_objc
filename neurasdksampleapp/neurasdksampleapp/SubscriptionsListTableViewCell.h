//
//  SubscriptionsListTableViewCell.h
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 9/16/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscriptionsListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchButton;

@end

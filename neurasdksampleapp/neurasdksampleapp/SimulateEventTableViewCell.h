//
//  SimulateEventTableViewCell.h
//  NeuraSDKSampleApp
//
//  Created by Neura on 11/07/2017.
//  Copyright © 2017 Neura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimulateEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property NSString *eventNameForEnum;

- (IBAction)sendEventAction:(UIButton*)sender;


@end

//
//  SimulateEventTableViewCell.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 11/07/2017.
//  Copyright © 2017 Neura. All rights reserved.
//

#import "SimulateEventTableViewCell.h"
#import <NeuraSDK/NeuraSDK.h>

@implementation SimulateEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sendBtn.layer.cornerRadius = 5.2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sendEventAction:(UIButton*)sender {
    NEventName enumEventName = [NEvent enumForEventName:self.eventNameForEnum];
    [NeuraSDK.shared simulateEvent:(enumEventName) callback:^(NeuraAPIResult * result){
        NSString * title = result.success ? @"Approve" : @"Error";
        NSString * message = result.errorString ? result.errorString : @"Sucsess";
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            while (topController.presentedViewController) {
                topController = topController.presentedViewController;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
            [topController presentViewController:alertVC animated:true completion:^(void){}];
            });
        
        
    }];
}
@end

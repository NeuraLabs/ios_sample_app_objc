//
//  SendEventsViewController.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 11/07/2017.
//  Copyright © 2017 Neura. All rights reserved.
//

#import "SendEventsViewController.h"
#import "SimulateEventTableViewCell.h"
#import <NeuraSDK/NeuraSDK.h>

@interface SendEventsViewController ()
@property (weak,   nonatomic) IBOutlet UITableView *eventsTebleView;
@property (strong, nonatomic) NSMutableArray <NSString *> *eventNames;

@end

@implementation SendEventsViewController

- (IBAction)backButtonPressed:(UIButton *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NeuraSDK.shared getEventsListWithCallback:^(NeuraEventsListResult * _Nonnull result){
        NSArray<NEvent *> *eventDefinitions = result.eventDefinitions;
        self.eventNames = [NSMutableArray new];
        
        if (result.eventDefinitions.count > 0) {
           for (NEvent * item in eventDefinitions) {
                [self.eventNames addObject:item.name];
            }
                [self.eventsTebleView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimulateEventTableViewCell *cell = (SimulateEventTableViewCell *)[self.eventsTebleView dequeueReusableCellWithIdentifier:@"SimulateEventCell"];

    NSString *eventName = self.eventNames[indexPath.item];
    
    NEventName enumEventName = [NEvent enumForEventName:eventName];
    if (enumEventName == NEventNameUndefined ){
        cell.sendBtn.hidden = YES;
    } else {
        cell.sendBtn.hidden = NO;
    }

    [cell.eventName setText:eventName];
    [cell.eventName adjustsFontSizeToFitWidth];
     cell.eventNameForEnum = eventName;
    
    return cell;
}

@end

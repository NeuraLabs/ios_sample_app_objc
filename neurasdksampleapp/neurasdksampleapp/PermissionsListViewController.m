//
//  PermissionsListViewController.m
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 9/13/15.
//  Copyright (c) 2015 Neura. All rights reserved.
//

#import "PermissionsListViewController.h"
#import <NeuraSDK/NeuraSDK.h>

@interface PermissionsListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *permissionsTableView;
@property (strong, nonatomic) NSArray *permissionsArray;
- (IBAction)backButtonPressed:(id)sender;
@end

@implementation PermissionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NeuraSDK sharedInstance] getAppPermissionsWithHandler:^(NSArray *permissionsArray, NSString *error) {
        if (!error) {
            self.permissionsArray = permissionsArray;
            [self.permissionsTableView reloadData];
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
    static NSString *simpleTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSDictionary *permissionDictionary = [self.permissionsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = permissionDictionary[@"displayName"];
    return cell;
}

#pragma mark - User action
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

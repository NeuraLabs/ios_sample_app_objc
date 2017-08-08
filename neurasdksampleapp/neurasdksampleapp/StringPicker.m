//
//  StringPicker.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 02/06/2016.
//  Copyright © 2016 Neura. All rights reserved.
//

#import "StringPicker.h"

@interface StringPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *selectedValue;
@property (nonatomic,copy) StringPickerHandler handler;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) UIViewController *controller;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPicker;

- (IBAction)doneButtonClick:(id)sender;
- (IBAction)cancelButtonClick:(id)sender;
@end

@implementation StringPicker



- (void)viewWillAppear:(BOOL)animated {
    self.doneButton.layer.cornerRadius = self.doneButton.frame.size.height / 2;
    self.doneButton.clipsToBounds = YES;
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height / 2;
    self.cancelButton.clipsToBounds = YES;
    
    self.titleLabel.text = self.titleText;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)showPickerWithTitle:(NSString *)title buttons:(int)buttons rows:(NSArray *)data WithHandler:(StringPickerHandler)handler {
    
    StringPicker *stringPicker = [[StringPicker alloc] initWithNibName:@"StringPicker" bundle:nil];
    stringPicker.view.alpha = 0;
    stringPicker.titleText = title;
    stringPicker.dataArray = data;
    stringPicker.handler = handler;
    stringPicker.selectedIndex = 0;
    stringPicker.selectedValue = data[0];

    if (buttons == 1) {
        stringPicker.doneButton.alpha = 0;
        [stringPicker.cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    }
    
    UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topViewController.presentedViewController) {
        topViewController = topViewController.presentedViewController;
    }
    
    stringPicker.controller = topViewController;
    stringPicker.providesPresentationContextTransitionStyle = YES;
    stringPicker.definesPresentationContext = YES;
    stringPicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [topViewController presentViewController:stringPicker
                                    animated:NO
                                  completion:^{
                                      [UIView animateWithDuration:0.1 animations:^{
                                          stringPicker.view.alpha = 1;
                                      }];
                                  }];
}



#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArray[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedValue = self.dataArray[row];
    _selectedIndex = row;
}


- (IBAction)doneButtonClick:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.controller dismissViewControllerAnimated:YES completion:^{
            self.handler(_selectedIndex,_selectedValue);
        }];
    }];
}


- (IBAction)cancelButtonClick:(id)sender
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.controller dismissViewControllerAnimated:YES completion:nil];
                     }];
}


@end

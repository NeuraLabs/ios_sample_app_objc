//
//  StringPicker.h
//  NeuraSDKSampleApp
//
//  Created by Gal Mirkin on 02/06/2016.
//  Copyright © 2016 Neura. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StringPickerHandler)(NSInteger selectedIndex, NSString *selectedValue);
@interface StringPicker : UIViewController

+(void)showPickerWithTitle:(NSString *)title buttons:(int)buttons rows:(NSArray *)data WithHandler:(StringPickerHandler)handler;

@end

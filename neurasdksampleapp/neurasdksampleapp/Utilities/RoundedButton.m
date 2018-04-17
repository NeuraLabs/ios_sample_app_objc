//
//  RoundedButton.m
//  NeuraSDKSampleApp
//
//  Created by Neura on 06/02/2018.
//  Copyright © 2018 Neura. All rights reserved.
//

#import "RoundedButton.h"

@implementation RoundedButton

- (void) layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.bounds.size.height/2;
}

@end

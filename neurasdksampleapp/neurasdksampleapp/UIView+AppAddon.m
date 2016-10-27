//
//  UIView+AppAddon.m
//  NeuraSDKSampleApp
//
//  Created by Genady Buchatsky on 23/08/2016.
//  Copyright © 2016 Neura. All rights reserved.
//

#import "UIView+AppAddon.h"

@implementation UIView (AppAddon)

-(float) x {
    return self.frame.origin.x;
}


-(void) setX:(float) newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}


-(float) y {
    return self.frame.origin.y;
}


-(void) setY:(float) newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}


-(float) width {
    return self.frame.size.width;
}


-(void) setWidth:(float) newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}


-(float) height {
    return self.frame.size.height;
}


-(void) setHeight:(float) newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}


- (void)roundCorners {
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.clipsToBounds = YES;
}


- (void)addImageViewShadow {
    self.clipsToBounds = YES;
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowRadius = 5.0f;
}

- (void)addDarkLayerWithAlpha:(float)alpha {
    if (![self viewWithTag:123455]) {
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        UIView *darkView = [[UIView alloc] initWithFrame:frame];
        darkView.tag = 123455;
        darkView.bounds = self.bounds;
        darkView.backgroundColor = [UIColor blackColor];
        darkView.alpha = alpha;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = darkView.center;
        [self addSubview:darkView];
        [darkView addSubview:spinner];
        [darkView bringSubviewToFront:spinner];
        [spinner startAnimating];
    }
    else {
        UIView *darkView = [self viewWithTag:123455];
        darkView.alpha = alpha;
        darkView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        if (alpha == 0) {
            [darkView removeFromSuperview];
        }
    }
}

- (void)removeDarkLayer {
    if ([self viewWithTag:123455]) {
        [[self viewWithTag:123455] removeFromSuperview];
    }
}

@end

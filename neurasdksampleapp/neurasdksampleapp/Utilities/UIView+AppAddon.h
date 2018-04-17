//
//  UIView+AppAddon.h
//  NeuraSDKSampleApp
//
//  Created by Genady Buchatsky on 23/08/2016.
//  Copyright © 2016 Neura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AppAddon)


@property float x;
@property float y;
@property float width;
@property float height;


- (void)roundCorners;
- (void)addImageViewShadow;
- (void)removeDarkLayer;
- (void)addDarkLayerWithAlpha:(float)alpha;


@end

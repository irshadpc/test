//
//  UIColor+RTTFromHex.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/12/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RTTFromHex)
+ (UIColor *)fromHex:(NSUInteger)rgbValue;
+ (UIColor *)fromHex:(NSUInteger)rgbValue alpha:(float)alpha;
@end

//
//  UIColor+Cocos.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/12/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface UIColor (Cocos)

@property (readonly) ccColor3B c3b;
@property (readonly) ccColor4B c4b;
@property (readonly) ccColor4F c4f;

-(void)setCCDrawColor;
@end

//
//  UIColor+Cocos.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/12/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "UIColor+Cocos.h"

@implementation UIColor (Cocos)
-(ccColor3B)c3b {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    return ccc3(0xFF * rgba[0], 0xFF * rgba[1], 0xFF * rgba[2]);
}

-(ccColor4B)c4b {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    return ccc4(0xFF * rgba[0], 0xFF * rgba[1], 0xFF * rgba[2], 0xFF * rgba[3]);
}

-(ccColor4F)c4f {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    return (ccColor4F) { (GLfloat) rgba[0], (GLfloat) rgba[1], (GLfloat) rgba[2], (GLfloat) rgba[3] };
}

-(void)setCCDrawColor {
    const CGFloat *rgba = CGColorGetComponents(self.CGColor);
    ccDrawColor4F(rgba[0], rgba[1], rgba[2], rgba[3]);
}
@end

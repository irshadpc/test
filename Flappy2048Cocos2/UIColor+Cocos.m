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

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

@end

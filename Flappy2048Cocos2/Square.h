//
//  Square.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObject.h"




@interface Square : GameObject{
    __unsafe_unretained CCArray *_tileColor;
    __unsafe_unretained CCArray *_tileColor2;
    __unsafe_unretained CCArray *_textColor;
    __unsafe_unretained UIColor *c;
}
@property (assign, nonatomic) long _valueNumber;
@property (assign, nonatomic) float _x;
@property (assign, nonatomic) float _y;
@property (strong, nonatomic) CCArray *_tileColor;
@property (strong, nonatomic) CCArray *_tileColor2;
@property (strong, nonatomic) CCArray *_textColor;
@property (strong, nonatomic) UIColor *c;


-(void)updatePosition:(CGPoint)newPoint;
-(void)moveLeft:(float)deltaX;
-(void)setNumber:(long)number;
-(void)setNumberWithOldColor:(long)number;
-(float)width;
-(float)height;
-(UIColor*)color;
@end

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
}
@property (assign, nonatomic) long _valueNumber;
@property (assign, nonatomic) float _x;
@property (assign, nonatomic) float _y;


-(void)updatePosition:(CGPoint)newPoint;
-(void)moveLeft:(float)deltaX;
-(void)setNumber:(long)number;
-(float)width;
-(float)height;
@end

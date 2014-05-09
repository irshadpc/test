//
//  GameObject.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameObject : NSObject
{
    CCSprite *sprite;
    CCLayer  *parentLayer;
    float pos_x, pos_y;
	float vel_x, vel_y;
	float acc_x, acc_y;
    float speed;
    
}

@property (strong, nonatomic) CCSprite *sprite;
@property ( readwrite ) float pos_x;
@property ( readwrite ) float pos_y;
@property ( readwrite ) float vel_x; // van toc
@property ( readwrite ) float vel_y;
@property ( readwrite ) float acc_x; // gia toc
@property ( readwrite ) float acc_y;


-(id)initWithGameLayer:(CCLayer *)aLayer;
-(void)update:(ccTime)delta;
-(void)putOn;
-(void)layerDidTouched:(UITouch*)aTouch;
-(void)updatePosition:(CGPoint)pos;
@end

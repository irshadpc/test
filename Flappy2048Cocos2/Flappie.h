//
//  Flappie.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Game.h"
#import "GameObject.h"

typedef enum {
    STANDING,
    FLAPPYNG,
    SLIDING,
    DIE,
    
}FlappieStatus;

@interface Flappie : GameObject {
    CCSprite *_wingFrame;
    CCSprite *_wingContent;
    CCSprite *_blockFrame;
    CCSprite *_blockContent;
    CCLabelTTF *_valueLabel;
    
    id _actionFlapUp;
    id _actionFlapDown;
    
    id _actionScaleUp;
    id _actionScaleDown;
    id _actionSquenceScale;
    
    float _angle;
    NSTimeInterval _sinceTouch;
    
    float layerWidth;
    float layerHeight;
    float minimunY;
    BOOL _affectByGravity;
    BOOL _affectByTouch;
    float _preVel_y;
    BOOL _isSliding;
    long long _valueNumber;
    FlappieStatus _status;
    FlappieStatus _prevStatus;
}
@property (assign, nonatomic) float _x;
@property (assign, nonatomic) float _y;
@property (assign, nonatomic) float _velY;
@property (assign, nonatomic) float _accY;
@property (assign, nonatomic) float _angle;
@property (assign, nonatomic) FlappieStatus _status;

-(id)initWithGameLayer:(CCLayer *)aLayer;
-(void)updateFlappi;
-(void)flap:(float)height;
-(void)setFlappieStatus:(FlappieStatus)status;
-(void)updateNumber:(long long)number;
-(void)setColor:(UIColor*)color;
@end

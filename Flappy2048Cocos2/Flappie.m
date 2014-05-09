//
//  Flappie.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "Flappie.h"
static const float GRAVITY = -1180.0f;
static const float IMPULSE = 330.0f;
@implementation Flappie

@synthesize _angle;

-(id)initWithGameLayer:(CCLayer *)aLayer
{
    if(self =  [super initWithGameLayer:aLayer]){
        pos_x = viewSize.width / 2;
        pos_y = viewSize.height / 2;
        vel_x = 0;
        vel_y = 0;
        acc_x = 0;
        acc_y = GRAVITY;
        _status = STANDING;
        _sinceTouch = 0.0f;
        [self loadSprite];
        layerHeight = viewSize.height;
        layerWidth = viewSize.width;
        CCSprite* groundTemp = [CCSprite spriteWithFile:@"ground.png"];
        minimunY = groundTemp.contentSize.height;
    }
    return self;
}

#pragma mark
-(void)update:(ccTime)delta{
    switch (_status) {
        case STANDING:
            break;
        case FLAPPYNG:
            pos_x = ((int)pos_x + (int)layerWidth) % (int)layerWidth;
            vel_y += acc_y * delta;
            pos_y += vel_y * delta;
            pos_x += vel_x * delta;
            if(pos_y-60 <= minimunY){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"nt_impact_ground" object:nil];
                vel_y = IMPULSE + fabsf(vel_x);
            }else{
                
            }
            
            [sprite setPosition:ccp(pos_x, pos_y)];
            if(vel_y >0){
                if(_angle+(vel_y * delta)< 60)
                {
                    _angle += (vel_y * delta);
                }
            }
            if(vel_y <0)
            {
                if(_angle+(vel_y * delta)>- 120)
                {
                    _angle += (vel_y * delta);
                }
            }
            sprite.rotation = -_angle/3;
            break;
        case SLIDING:
            _sinceTouch = 0.0f;
            vel_y = 0;
            [sprite setRotation:0];
            break;
        case DIE:
            break;
    }
    
}

-(void)layerDidTouched:(UITouch *)aTouch
{
    vel_y = IMPULSE;
    if(_sinceTouch == 0)
        _sinceTouch = 1.0f;
}

#pragma mark public methods
-(void)putOn{
    pos_x = viewSize.width/4;
    pos_y = 2/3*viewSize.height;
    [parentLayer addChild:sprite z:2];
}
-(void)updateFlappi
{
    sprite.position = ccp(pos_x, pos_y);
}

-(void)flap:(float)height
{
    self._velY = height;
}

#pragma mark private methods
-(void)loadSprite
{
    _wingFrame = [CCSprite spriteWithSpriteFrameName:@"wing-frame"];
    _wingContent = [CCSprite spriteWithSpriteFrameName:@"wing-content"];
    _wingContent.anchorPoint = ccp(1.0, 0.5);
    _wingFrame.anchorPoint = ccp(1.0, 0.5);
    _blockFrame = [CCSprite spriteWithSpriteFrameName:@"block-frame"];
    _blockContent = [CCSprite spriteWithSpriteFrameName:@"block-content"];
    _valueLabel = [CCLabelTTF labelWithString:@"1"
                                     fontName:@"Helvetica"
                                     fontSize:40
                                   dimensions:_blockContent.contentSize
                                   hAlignment:kCCTextAlignmentCenter
                                   vAlignment:kCCTextAlignmentCenter
                                lineBreakMode:kCCLabelAutomaticWidth];
    _valueLabel.color = ccc3(0, 0, 0);
    sprite = [CCSprite node];
    [sprite addChild:_blockContent];
    [sprite addChild:_valueLabel];
    [sprite addChild:_blockFrame];

    _wingFrame.position = ccp(-_blockFrame.contentSize.width/4, _blockFrame.contentSize.height/4);
    _wingContent.position = ccp(-_blockFrame.contentSize.width/4, _blockFrame.contentSize.height/4);
    
    [sprite addChild:_wingContent];
    [sprite addChild:_wingFrame];
    sprite.anchorPoint = ccp(0, 0.5);
    sprite.contentSize = _blockContent.contentSize;
    [self initAction];
}

-(void)initAction
{
    _actionFlapUp = [CCRotateTo actionWithDuration:.2f angle:-15.0f];
    _actionFlapDown = [CCRotateTo actionWithDuration:.2f angle:30.0f];
    _actionScaleUp =  [CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:1 scaleX:1.0 scaleY:1.0] rate:2.0];
    _actionScaleDown = [CCEaseInOut actionWithAction:[CCScaleTo actionWithDuration:0.5 scaleX:0.8 scaleY:0.8] rate:2.0];
    _actionSquenceScale = [CCSequence actions:_actionScaleUp, _actionScaleDown, nil];
    
    [_wingFrame runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:_actionFlapUp two:_actionFlapDown]]];
    [_wingContent runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[_actionFlapUp copy] two:[_actionFlapDown copy]]]];
}

-(void)setFlappieStatus:(FlappieStatus)status{
    _status = status;
}

@end

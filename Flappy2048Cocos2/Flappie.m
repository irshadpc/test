//
//  Flappie.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "Flappie.h"
#import "SimpleAudioEngine.h"
#import "UIColor+Cocos.h"

static const float GRAVITY = -1080.0f;
static const float IMPULSE = 330.0f;
@implementation Flappie

@synthesize _angle;

-(id)initWithGameLayer:(CCLayer *)aLayer
{
    if(self =  [super initWithGameLayer:aLayer]){
        pos_x = viewSize.width / 2;
        pos_y = 3*viewSize.height / 5;
        vel_x = 0;
        vel_y = pos_y;
        acc_x = 0;
        acc_y = GRAVITY;
        _status = STANDING;
        _prevStatus = STANDING;
        _sinceTouch = 0.0f;
        [self loadSprite];
        layerHeight = viewSize.height;
        layerWidth = viewSize.width;
        CCSprite* groundTemp = [CCSprite spriteWithFile:@"ground.png"];
        minimunY = groundTemp.contentSize.height;
        _affectByGravity = NO;
        _affectByTouch = YES;
        _isSliding = NO;
        _valueNumber = 1;
    }
    return self;
}

-(void)updateNumber:(long)number
{
    _valueNumber=number;
    [_valueLabel setFontSize:[self calculateFontSizeForString:[NSString stringWithFormat:@"%ld", _valueNumber] fontName:@"Helvetica"]];
    _valueLabel.string = [NSString stringWithFormat:@"%ld", _valueNumber];
}
- (int) calculateFontSizeForString:(NSString*)string fontName:(NSString*)usedFontName
{
    int fontSize = 40; // it seems to be the biggest font we can use
    while (--fontSize > 0) {
        CGSize size = [string sizeWithFont:[UIFont fontWithName:usedFontName size:fontSize]];
        if (size.width <= sprite.contentSize.width-10 && size.height <= sprite.contentSize.height -10)
            break;
    }
    
    return fontSize;
}
#pragma mark
-(void)update:(ccTime)delta{
    switch (_status) {
        case STANDING:
            break;
        case FLAPPYNG:
            if(_affectByGravity)
            {
                pos_x = ((int)pos_x + (int)layerWidth) % (int)layerWidth;
                vel_y += acc_y * delta;
                pos_y += vel_y * delta;
                pos_x += vel_x * delta;
                if(pos_y-60 <= minimunY){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"nt_impact_ground" object:nil];
                    vel_y = IMPULSE + fabsf(vel_x);
                }
                
                [sprite setPosition:ccp(pos_x, pos_y)];
                if(vel_y >0){
                    if(_angle+(vel_y * delta)< 60)
                    {
                        _angle += (vel_y * delta)*1.5 ;
                    }
                }
                if(vel_y <0)
                {
                    if(_angle+(vel_y * delta)>- 120)
                    {
                        _angle += (vel_y * delta);
                    }
                }
                [sprite setRotation:-_angle/2 ];
            }
            break;
        case SLIDING:
            if(!_isSliding){
                _status = _prevStatus;
                _affectByGravity = YES;
                _affectByTouch = YES;
                vel_y = _preVel_y;
                _preVel_y = 0;
            }else{
                _sinceTouch = 0.0f;
                vel_y = 0;
                [sprite setRotation:0];
            }
           
            break;
        case DIE:
            if(_affectByGravity)
            {
                pos_x = ((int)pos_x + (int)layerWidth) % (int)layerWidth;
                vel_y += acc_y * delta;
                pos_y += vel_y * delta;
                if(pos_y<minimunY+sprite.contentSize.height){
                    pos_y = minimunY+sprite.contentSize.height;
                }
                pos_x += vel_x * delta;
                [sprite setPosition:ccp(pos_x, pos_y)];
                [sprite setRotation:0 ];
            }
            break;
    }
    
}

-(void)layerDidTouched:(UITouch *)aTouch
{
    if(_affectByTouch)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_wing.caf"];
        vel_y = IMPULSE;
        if(_sinceTouch == 0)
            _sinceTouch = 1.0f;
    }else{
        
    }
}

#pragma mark public methods
-(void)putOn{
    pos_x = [CCDirector sharedDirector].winSize.width/4;
    pos_y = (float)2.0/3*[CCDirector sharedDirector].winSize.height;
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
    _valueLabel.color = ccc3(255, 255, 255);
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

-(void)setColor:(UIColor*)color{
    _blockContent.color = [color c3b];
    _wingContent.color = [color c3b];
}

-(void)initAction
{
    _actionFlapUp = [CCRotateTo actionWithDuration:.2f angle:-15.0f];
    _actionFlapDown = [CCRotateTo actionWithDuration:.2f angle:30.0f];
   
    _actionScaleUp =  [CCScaleTo actionWithDuration:0.3 scale:2.0];
    _actionScaleDown = [CCScaleTo actionWithDuration:0.3 scale:1.0];
    _actionSquenceScale = [CCSequence actionOne:_actionScaleUp two:_actionScaleDown];
    
    [_wingFrame runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:_actionFlapUp two:_actionFlapDown]]];
    [_wingContent runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[_actionFlapUp copy] two:[_actionFlapDown copy]]]];
}

-(void)setFlappieStatus:(FlappieStatus)status
{
    if(status == _status) return;
    _prevStatus = _status;
    _status = status;
    switch (_status)
    {
        case FLAPPYNG:
            _isSliding = NO;
            _affectByGravity = YES;
            _affectByTouch = YES;
            _prevStatus = FLAPPYNG;
            break;
        case STANDING:
            _isSliding = NO;
            _affectByTouch = NO;
            _affectByGravity = NO;
            _prevStatus = STANDING;
            break;
        case SLIDING:
            _affectByTouch = NO;
            _affectByGravity = NO;
            _preVel_y = vel_y;
            _isSliding = YES;
            break;
        case DIE:
            vel_y = 0;
            _isSliding = NO;
            _prevStatus = DIE;
            _affectByGravity = YES;
            _affectByTouch = NO;
            break;
    }
}
-(void)updatePosition:(CGPoint)pos{
    pos_x = pos.x;
    pos_y = pos.y;
    [sprite setPosition:pos];
}
@end

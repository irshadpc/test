//
//  Square.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "Square.h"


@implementation Square
{
    CCSprite *_frame;
    CCSprite *_content;
    CCLabelTTF *_valueLabel;
}
@synthesize _x, _y, _valueNumber;

-(id)initWithGameLayer:(CCLayer *)aLayer
{
    if(self = [super initWithGameLayer:aLayer])
    {
        _frame = [CCSprite spriteWithSpriteFrameName:@"block-frame"];
        _content = [CCSprite spriteWithSpriteFrameName:@"block-content"];
        _frame.anchorPoint = ccp(0.5, 0);
        _content.anchorPoint = ccp(0.5, 0);
        
        sprite = [CCSprite node];
        [sprite addChild:_content];
        [sprite addChild:_frame];
        sprite.contentSize = _frame.contentSize;
    }
    return self;
}

#pragma mark public methods
-(void)setNumber:(long)number
{
    _valueNumber = number;
    if(!_valueLabel)
    {
        _valueLabel = [CCLabelTTF labelWithString:@"Hi" fontName:@"Helvetica"
                                         fontSize:40
                                       dimensions:sprite.contentSize
                                       hAlignment:kCCTextAlignmentCenter
                                       vAlignment:kCCTextAlignmentCenter
                                    lineBreakMode:kCCLabelAutomaticWidth];
        _valueLabel.color = ccc3(0, 0, 0);
        _valueLabel.anchorPoint = ccp(0.5, 0);
        [sprite addChild:_valueLabel];
    }
    else{

    }
    DLog(@"Set me : %ld", number);
    [_valueLabel setString:[NSString stringWithFormat:@"%ld", _valueNumber]];
}

-(void)updatePosition:(CGPoint)newPoint
{
    _x = newPoint.x;
    _y = newPoint.y;
    [sprite setPosition:newPoint];
}

-(void)moveLeft:(float)deltaX
{
    _x = _x - deltaX;
}
-(float)width{ return sprite.contentSize.width;}
-(float)height{ return sprite.contentSize.height;}
@end

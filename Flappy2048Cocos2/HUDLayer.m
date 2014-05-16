//
//  HUDLayer.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/13/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "HUDLayer.h"
#import "Game.h"

@implementation HUDLayer

-(id) init{
    if(self = [super init]){
        _hightScore = [game highestScore];
        [self setContentSize:viewSize];
        _scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:FONT fontSize:40];
        _scoreLabel.position = ccp(viewSize.width - 20 - _scoreLabel.contentSize.width / 2, 20);
        _scoreLabel.color = ccc3(0, 0, 0);
        [self addChild:_scoreLabel];
        
        _soundOnMenuItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"sound-on"]
                                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"sound-on"]];
        _soundOffMenuItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"sound-off"]
                                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"sound-off"]];
        _soundMenuToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleSound) items:_soundOnMenuItem, _soundOffMenuItem, nil];
        
        BOOL soundOn = [game soundOn];
        if(!soundOn){
            [_soundMenuToggle setSelectedIndex:1];
        }
        _soundMenu  = [CCMenu menuWithItems:_soundMenuToggle, nil];
        [_soundMenu alignItemsVertically];
        [_soundMenu setPosition:ccp(50, 25)];
        
        [self addChild:_soundMenu];
    }
    return self;
}


-(void)toggleSound
{
    if(_soundMenuToggle.selectedIndex==0){
        DLog(@"Toggle On");
        [game  turnSound:YES];
    }else{
        DLog(@"Toggle Off");
        [game  turnSound:NO];
    }
}


-(void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    
}
-(void)increseScore{
    [self setScore:_score+1];
    if(_score > _hightScore){
        _hightScore = _score;
        [game updateHightScore:_hightScore];
    }
    _scoreLabel.position = ccp(viewSize.width - 20 - _scoreLabel.contentSize.width / 2, 20);
}
-(void)setScore:(int)score{
    _score = score;
    id zoomIn = [CCScaleTo actionWithDuration:0.2 scale:1.5];
    id zoomOut = [CCScaleTo actionWithDuration:0.2 scale:1.0];
    id sequence = [CCSequence actionOne:zoomIn two:zoomOut];
    id action = [CCRepeat actionWithAction:sequence times:1];
    [_scoreLabel setString:[NSString stringWithFormat:@"%d", _score]];
    [_scoreLabel runAction:action];
    
    if(_score > _hightScore){
        _hightScore = _score;
        [game updateHightScore:_hightScore];
    }
    
}

-(void)setHightScore:(int)score
{
    _hightScore = score;
    if(!_hightScoreLabel)
    {
        _hightScoreLabel = [CCLabelTTF labelWithString:@"Best Score" fontName:@"Helvetica" fontSize:30];
        _hightScoreLabel.color = ccc3(0, 0, 0);
        _hightScoreLabel.position = ccp(3*viewSize.width/4, viewSize.height - 100);
        [self addChild:_hightScoreLabel];
    }
    [_hightScoreLabel setString:[NSString stringWithFormat:@"%d", _hightScore]];
}

-(void)resetScore
{
    [self setScore:0];
    DLog(@"High score: %d", _hightScore);
}
@end

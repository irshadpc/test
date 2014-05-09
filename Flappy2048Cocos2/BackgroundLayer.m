//
//  BackgroundLayer.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

-(id)initWithParentLayer:(CCLayer*)aLayer{
    if(self = [super init]){
        _parentLayer = aLayer;
        _bg = [CCSprite spriteWithFile:@"bg.png"];
        _ground = [CCSprite spriteWithFile:@"ground.png"];
        _groundLine = [CCSprite spriteWithFile:@"ground-line.png"];
        _groundLineBuffer = [CCSprite spriteWithFile:@"ground-line.png"];
        [self setupWorld];
    }
    return self;
}

-(void)setupWorld{
    self.anchorPoint = ccp(0.5, 0);
    _bg.anchorPoint = ccp(0.5, 0);
    _bg.position  = ccp(viewSize.width/2, 0);
    [self addChild:_bg];
    _ground.anchorPoint = ccp(0.5, 0);
    _ground.position  = ccp(viewSize.width/2, 0);
    [self addChild:_ground];
    _groundLine.anchorPoint = ccp(0.5, 1.0);
    _groundLine.position  = ccp(viewSize.width/2, _ground.contentSize.height);
    [self addChild:_groundLine];
    _groundLineBuffer.anchorPoint = ccp(0.5, 1.0);
    _groundLineBuffer.position  = ccp(_groundLine.position.x + _groundLine.contentSize.width/2 + _groundLineBuffer.contentSize.width/2, _ground.contentSize.height);
    [self addChild:_groundLineBuffer];
    [self scheduleUpdate];
}

-(void)update:(ccTime)delta{
    [_groundLine setPosition:ccp(_groundLine.position.x - 2, _groundLine.position.y)];
    if(_groundLine.position.x < - _groundLine.contentSize.width/2){
        _groundLine.position = ccp(_groundLineBuffer.position.x + _groundLineBuffer.contentSize.width/2 + _groundLine.contentSize.width/2,_groundLine.position.y);
    }
    
    [_groundLineBuffer setPosition:ccp(_groundLineBuffer.position.x - 2, _groundLineBuffer.position.y)];
    if(_groundLineBuffer.position.x < - _groundLineBuffer.contentSize.width/2){
        _groundLineBuffer.position = ccp(_groundLine.position.x + _groundLine.contentSize.width/2 + _groundLineBuffer.contentSize.width/2,_groundLineBuffer.position.y);
    }
}

@end

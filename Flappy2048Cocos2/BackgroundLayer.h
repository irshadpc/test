//
//  BackgroundLayer.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer {
    CCSprite * _bg;
    CCSprite * _ground;
    CCSprite * _groundLine;
    CCSprite * _groundLineBuffer;
    CCLayer *_parentLayer;
}

-(id)initWithParentLayer:(CCLayer*)aLayer;

@end

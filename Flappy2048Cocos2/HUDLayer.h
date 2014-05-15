//
//  HUDLayer.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/13/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    int _score;
    int _hightScore;
    
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_hightScoreLabel;
    CCMenu *_menu;
    CCMenuItemSprite *_soundMenuItem;
}
-(void)setContentSize:(CGSize)contentSize;
-(void)setScore:(int)score;
-(void)setHightScore:(int)score;
-(void)increseScore;
-(void)resetScore;
@end

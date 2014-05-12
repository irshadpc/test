//
//  Game.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CocosDenshion.h"
typedef enum {
    GAME_BEGIN,
    GAME_PAUSE,
    GAME_RUNNING,
    GAME_OVER,
}GameState;

#define FL_SCORE_UPDATE @"fl_score_updated"
#define FL_GAME_STATE_UPDATE @"fl_gamestate_update"
#define NT_GAME_GOTO_BACKGROUND @"fl_game_goto_background"
#define NT_GAME_RETURN_FOREGROUND @"fl_game_return_foreground"
@interface Game : NSObject

@property(assign, nonatomic) long currentValue;
@property(assign, nonatomic) long currentScore;
@property(assign, nonatomic) long highestScore;
@property(strong, nonatomic) NSDictionary *colorMap;
@property(strong, nonatomic) NSMutableDictionary *valueColorMapsDictionary;
@property (assign, nonatomic) GameState gameState;

+(Game*)sharedInstance;

-(void)loadCurrentUserInfo;
-(void)updateNewUserInfo;
-(void)registeGameNotification;
-(void)unregisterGameNotification;
-(UIColor*)getColorFor:(long)number;
-(CCSprite*)loadSpriteFile:(NSString*)imageName;
@end

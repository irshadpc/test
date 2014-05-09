//
//  Game.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "Game.h"

#define KEY_HIGHT_SCORE @"fl_hight_score"

static Game *instance = nil;
@implementation Game
@synthesize currentValue, currentScore, highestScore, valueColorMapsDictionary;

+(Game*)sharedInstance{
    @synchronized(self){
        if(instance == nil){
            instance = [[Game alloc] init];
        }
        
        return instance;
    }
}
-(void)loadCurrentUserInfo
{
    NSUserDefaults *sharedUserDefault = [NSUserDefaults standardUserDefaults];
    NSInteger highScore = [sharedUserDefault integerForKey:KEY_HIGHT_SCORE];
    highestScore = (long)highScore;
    currentScore = 0;
    currentValue = 1;
    
}
-(void)updateNewUserInfo{
//    @synchronized(self)
    [[NSUserDefaults standardUserDefaults] setInteger:highestScore forKey:KEY_HIGHT_SCORE];
}

-(void)registeGameNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameGotoBackground:) name:NT_GAME_GOTO_BACKGROUND object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameReturnForeground:) name:NT_GAME_RETURN_FOREGROUND object:nil];
    
}
-(void)unregisterGameNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(CCSprite*)loadSpriteFile:(NSString*)imageName{
    CCSprite *sp = [CCSprite spriteWithFile:imageName];
    return  sp;
}
#pragma mark private methods
-(void)generateValueColorMapDictionary
{
    
    CCLOG(@"Did receive game goto background");
}

-(void)gameReturnForeGround:(NSNotification*)noti
{
    
    CCLOG(@"Did receive game return foreground");
}
@end

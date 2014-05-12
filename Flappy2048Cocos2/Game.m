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
@synthesize currentValue, currentScore, highestScore, valueColorMapsDictionary, colorMap, gameState;

-(id)init
{
    if(self = [super init]){
        colorMap = @{
                     @"0": @"eae8e4",
                     @"1": @"eae8e4",
                     @"2": @"eae8e4",
                     @"4": @"ede0ca",
                     @"8": @"edddba",
                     @"16": @"eddaab",
                     @"32": @"edd79b",
                     @"64": @"edd48b",
                     @"128": @"edd17c",
                     @"256": @"edce6c",
                     @"512": @"edcb5c",
                     @"1024": @"edc84d",
                     @"2048": @"edc53d",
                     };
    }
    return self;
}

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
-(UIColor*)getColorFor:(long)number{
    UIColor *color = [self colorFromHexString:[colorMap objectForKey:[NSString stringWithFormat:@"%ld", number]]];
    return  color;
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end

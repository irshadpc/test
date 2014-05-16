//
//  GameOverLayer.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/12/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "GameOverLayer.h"
#import "Game.h"

@implementation GameOverLayer
{
    CCMenu *menu;
    CCLabelTTF *_bestScoreLabel;
    CCLabelTTF *_bestScoreValueLabel;
    CCMenuItemLabel *_playAgainLabel;
    CCMenuItemSprite *_shareFbSprite;
    CCMenu *_menu;
}
@synthesize delegate;
-(id)init{
    if(self = [super init]){
        [self initControl];
    }
    return self;
}

-(void)initControl{
    float fontSize;
    _bestScoreLabel = [CCLabelTTF labelWithString:@"Best Score"
                                         fontName:FONT
                                         fontSize:30
                                       dimensions:CGSizeMake(viewSize.width-40, 40)
                                       hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    _bestScoreLabel.position = ccp(self.contentSize.width/2, self.contentSize.height - 60);
    [self addChild:_bestScoreLabel];
    
    _bestScoreValueLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%ld",[game highestScore]]
                                              fontName:FONT
                                              fontSize:30
                                            dimensions:CGSizeMake(viewSize.width-40, 40)
                                            hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    _bestScoreValueLabel.position = ccp(self.contentSize.width/2, self.contentSize.height - 120);
    [self addChild:_bestScoreValueLabel];
    _bestScoreValueLabel.color = ccc3(0, 0, 0);
    _bestScoreLabel.color = ccc3(0, 0, 0);
    
    fontSize = [self calculateFontSizeForString:@"Play Again" fontName:FONT];
    CCLabelTTF *_lb = [CCLabelTTF labelWithString:@"Play Again" fontName:FONT fontSize:fontSize dimensions:CGSizeMake(viewSize.width-40, 80) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    _lb.color = ccc3(0, 0, 0);
    _playAgainLabel = [CCMenuItemLabel itemWithLabel:_lb target:self selector:@selector(didTouchPlayAgain:)];
    _playAgainLabel.position = ccp(self.contentSize.width/2, self.contentSize.height/2 - 60);
    
//    fontSize = [self calculateFontSizeForString:@"Share to Facebook" fontName:FONT];
//    CCLabelTTF *_lbShare = [CCLabelTTF labelWithString:@"Share to Facebook" fontName:FONT fontSize:fontSize dimensions:CGSizeMake(viewSize.width, 80) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
//    _lbShare.color = ccc3(0, 0, 0);
    CCSprite * s = [CCSprite spriteWithFile:@"share-buttons.png"];
    CCSprite * s2 = [CCSprite spriteWithFile:@"share-buttons.png"];
    s.anchorPoint = ccp(0.5, 0.5);
    s2.anchorPoint = ccp(0.5, 0.5);
    _shareFbSprite = [CCMenuItemSprite itemWithNormalSprite:s selectedSprite:s2 target:self selector:@selector(didTouchShareFacebook:)];
    _shareFbSprite.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 60);
    
    _menu = [CCMenu menuWithItems:_playAgainLabel, _shareFbSprite, nil];
    _menu.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [_menu alignItemsVertically];

    [self addChild:_menu];
    
    CGPoint oldPoint = _playAgainLabel.position;
    id moveUp  =[CCMoveTo actionWithDuration:0.5 position:ccp(oldPoint.x, oldPoint.y + 10)];
    id moveDown  =[CCMoveTo actionWithDuration:0.5 position:ccp(oldPoint.x, oldPoint.y - 10)];
    id sequen = [CCSequence actions:moveUp, moveDown, nil];
    
    [_playAgainLabel runAction:[CCRepeatForever actionWithAction:sequen]];
}
- (int) calculateFontSizeForString:(NSString*)string fontName:(NSString*)usedFontName
{
    int fontSize = 40; // it seems to be the biggest font we can use
    while (--fontSize > 0) {
        CGSize size = [string sizeWithFont:[UIFont fontWithName:usedFontName size:fontSize]];
        if (size.width <= self.contentSize.width-10 && size.height <= self.contentSize.height -10)
            break;
    }
    
    return fontSize;
}
-(void)didTouchShareFacebook:(id)sender{
    if(delegate){
        if([delegate respondsToSelector:@selector(gameOverDidTouchShareFacebook)]){
            [delegate performSelector:@selector(gameOverDidTouchShareFacebook) withObject:nil];
        }
    }
}
-(void)didTouchPlayAgain:(id)sender
{
    if(delegate){
        if([delegate respondsToSelector:@selector(gameOverDidTouchPlayAgain)]){
            [delegate performSelector:@selector(gameOverDidTouchPlayAgain) withObject:nil];
        }
    }
}

-(void)reloadBestScore{
    _bestScoreValueLabel.string =  [NSString stringWithFormat:@"%ld",[game highestScore]];
}

@end

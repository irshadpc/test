//
//  GameOverLayer.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/12/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@protocol GameOverMenuDelegate;
@interface GameOverLayer : CCLayer {
    id<GameOverMenuDelegate> delegate;
}
@property (assign, nonatomic) id<GameOverMenuDelegate> delegate;
-(void)reloadBestScore;
@end

@protocol GameOverMenuDelegate <NSObject>
@required
-(void)gameOverDidTouchPlayAgain;
-(void)gameOverDidTouchShareFacebook;

@end

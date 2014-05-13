//
//  MenuLayer.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol MenuLayerDelegate;
@interface MenuLayer : CCLayer {
    CCMenu *_menu;
    CCMenuItemLabel *_clickToStartMenuItem;
    CCSprite *_logo;
    id<MenuLayerDelegate> _delegate;
}
@property(assign, nonatomic)id<MenuLayerDelegate> _delegate;
-(id)init;
@end

@protocol MenuLayerDelegate <NSObject>
@required
-(void)gameMenuDidTouchStart;

@end

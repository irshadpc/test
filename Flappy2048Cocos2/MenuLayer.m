//
//  MenuLayer.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "MenuLayer.h"


@implementation MenuLayer

@synthesize _delegate;

-(id)init{
    if(self = [super init]){
        _logo = [CCSprite spriteWithSpriteFrameName:@"logo"];
        _logo.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 100);
        _logo.scale = 0.9;
        [self addChild:_logo];
        
        CCLabelTTF *_lb = [CCLabelTTF labelWithString:@"Click to start" fontName:@"Helvetica" fontSize:40 dimensions:CGSizeMake(viewSize.width, 50) hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
        _lb.color = ccc3(0, 0, 0);
        _clickToStartMenuItem = [CCMenuItemLabel itemWithLabel:_lb target:self selector:@selector(didTouchStart:)];
        _menu = [CCMenu menuWithItems:_clickToStartMenuItem, nil];
        _menu.position = ccp(self.contentSize.width/2, self.contentSize.height/2 - 60);
        [_menu alignItemsVertically];
        [self addChild:_menu];
        
        CGPoint oldPoint = _menu.position;
        id moveUp  =[CCMoveTo actionWithDuration:0.5 position:ccp(oldPoint.x, oldPoint.y + 20)];
        id moveDown  =[CCMoveTo actionWithDuration:0.5 position:ccp(oldPoint.x, oldPoint.y - 20)];
        id sequen = [CCSequence actions:moveUp, moveDown, nil];
        [_menu runAction:[CCRepeatForever actionWithAction:sequen]];
        
    }
    return self;
}

-(void)didTouchStart:(id)sender
{
    if(_delegate)
    {
        if([_delegate respondsToSelector:@selector( gameMenuDidTouchStart)]){
            [_delegate performSelector:@selector(gameMenuDidTouchStart) withObject:nil];
            DLog(@"Click start !");
        }
    }
    DLog(@"CLick start");
}
@end

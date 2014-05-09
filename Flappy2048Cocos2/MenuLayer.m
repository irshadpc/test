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
        _logo.position = ccp(self.contentSize.width/2, self.contentSize.height/2 + 50);
        [self addChild:_logo];
        
        _clickToStartMenuItem = [[CCMenuItem alloc] initWithTarget:self selector:@selector(didTouchStart:)];
        _menu = [CCMenu menuWithItems:_clickToStartMenuItem, nil];
        [self addChild:_menu];
    }
    return self;
}

-(void)didTouchStart:(id)sender
{
    if(_delegate)
    {
        if([_delegate respondsToSelector:@selector( gameMenuDidTouchStart)]){
            [_delegate performSelector:@selector(gameMenuDidTouchStart) withObject:nil];
        }
    }
    DLog(@"CLick start");
}
@end

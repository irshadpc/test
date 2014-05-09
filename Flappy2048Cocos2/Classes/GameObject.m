//
//  GameObject.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
@synthesize vel_x, vel_y, pos_x, pos_y, acc_x, acc_y, sprite;
-(id)init{
    if(self = [super init]){
        // init object properties.
        
    }
    return self;
}

/*----------------------------------------------------------------------------
 Method:      <#method name#>   <#description#>
 -----------------------------------------------------------------------------*/
-(id)initWithGameLayer:(CCLayer *)aLayer{
    if(self = [super init]){
        parentLayer = aLayer;
        
    }
    return self;
}

/*----------------------------------------------------------------------------
 Method:      <#method name#>   <#description#>
 -----------------------------------------------------------------------------*/
-(void)update:(ccTime)delta{
}

-(void)putOn{
    [parentLayer addChild:sprite];
}

-(void)layerDidTouched:(UITouch*)aTouch{
    NSAssert(1, @"This method has to be overrided");
    // override this methods
}
-(void)updatePosition:(CGPoint)pos{
    pos_x = pos.x;
    pos_y = pos.y;
    [sprite setPosition:pos];
}
@end

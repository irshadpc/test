//
//  MainScene.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface MainScene : CCLayer
+(CCScene*)scene;
-(void)initData;
-(CGPoint)distanceXYWithFlappi:(CGPoint)pos;
-(CGPoint)posFlappi;
-(void)removeRedLayer;
@end

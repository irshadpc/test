//
//  Macro.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#ifndef Flappy2048Cocos2_Macro_h
#define Flappy2048Cocos2_Macro_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define game [Game sharedInstance]
#define viewSize  [CCDirector sharedDirector].winSize

#endif

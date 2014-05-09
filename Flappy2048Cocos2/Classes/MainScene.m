
//
//  MainScene.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//

#import "MainScene.h"
#import "Flappie.h"
#import "Square.h"
#import "MenuLayer.h"
#import "BackgroundLayer.h"
#import "ColumnLayer.h"

typedef enum {
    GAME_BEGIN,
    GAME_PAUSE,
    GAME_RUNNING,
    GAME_OVER,
}GameState;

@interface MainScene()<ColumnLayerDelegate>

@end

@implementation MainScene{

    MenuLayer *_starMenuLayer;
    BackgroundLayer *_backgroundLayer;
    CCLayer *_gameOverLayer;
    CCLayer *_mainLayer;
    
    NSMutableArray *_sprites;
    NSMutableArray *_allSquare;
    
    Flappie *_flap;
    
    //word gravity
    
    //Resrouce bacthnode
    CCSpriteBatchNode *_batchNode;
    GameState _gameState;
    
    ColumnLayer *_col;
    ColumnLayer *_colBuffer;
    
    float _distance2Col;
    
}

+(CCScene*)scene{
    CCScene *scene = [CCScene node];
    MainScene *mainScene = [MainScene node];
    [mainScene initData];
    [scene addChild:mainScene];
    return scene;
}
-(id)init{
    if(self = [super init])
    {
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"flappy2048.pvr"];
        [self addChild:_batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flappy2048.plist"];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        _backgroundLayer = [[[BackgroundLayer alloc] initWithParentLayer:self] autorelease];
        _backgroundLayer.anchorPoint = ccp(0, 0);
        [self addChild:_backgroundLayer];
        [self initFlappi];
        [self initCol];
        // start schedule update
        [self scheduleUpdate];
        //
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(didImpactGround:) name:@"nt_impact_ground" object:nil];
    }
    return self;
}

-(void)didImpactGround:(NSNotification*)noti
{
}

-(void)initData{
    DLog(@"Init New game");
    _gameState = GAME_PAUSE;
    [self initGameMenuLayer];
}

-(void)initGameMenuLayer{
    _starMenuLayer = [[[MenuLayer alloc] init] autorelease];
    _starMenuLayer.anchorPoint = ccp(0, 0);
    _starMenuLayer.contentSize = CGSizeMake(viewSize.width, viewSize.height);
}

-(void)initFlappi{
    _sprites = [[NSMutableArray alloc] init];
    _flap = [[Flappie alloc] initWithGameLayer:self];
    [_flap updatePosition:ccp(self.contentSize.width/4, self.contentSize.height/2)];
    // add to screen
    [_flap putOn];
    // add to array to handler in game logic
    [_sprites addObject:_flap];
}

-(void)initCol
{
    _distance2Col = viewSize.width - 50;
    _col = [[ColumnLayer alloc] initBlocksWitnValue:0 parentLayer:self];
    _col._columIndex = 0;
    
    _colBuffer = [[ColumnLayer alloc] initBlocksWitnValue:1 parentLayer:self];
    _colBuffer._columIndex = 1;
    
    [_col set_delegate:self];
    [_colBuffer set_delegate:self];
    
    _col.anchorPoint = ccp(0.5, 0);
    _colBuffer.anchorPoint = ccp(0.5, 0);
    
    CCSprite* groundTemp = [CCSprite spriteWithFile:@"ground.png"];
    Square* sqtemp = [[Square alloc] initWithGameLayer:self];
    
    [_col updatePosition:ccp(viewSize.width - [sqtemp width]*2, groundTemp.contentSize.height)];
    [self addChild:_col z:1];
    [_col activate];
    
    [_colBuffer updatePosition:ccp(_col.position.x + _col.contentSize.width /2 + _distance2Col, groundTemp.contentSize.height)];
    [self addChild:_colBuffer z:1];
    [_colBuffer activate];
    
    [_sprites addObject:_col];
    [_sprites addObject:_colBuffer];
    
    [_flap setFlappieStatus:FLAPPYNG];
    
}

#pragma mark ColumnDelgate

-(void)columnDidOutOffScreen:(int)index{
    if(index==0){ // main index
        [_col moveToStatOfParent];
        [_col mul4];
    }
    else if(index==1){ // buffer
        [_colBuffer moveToStatOfParent];
        [_colBuffer mul4];
    }
}

#pragma mark Game Timer Update
-(void)update:(ccTime)delta
{
    // donothing yet
//    float deltaY =
    if([_sprites count] >0)
    {
        [_sprites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GameObject* o = (GameObject *)obj;
            [o update:delta];
        }];
    }
}

#pragma mark touch handler
#pragma mark - Touch handler
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if([_sprites count] >0)
    {
        [_sprites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GameObject* o = (GameObject *)obj;
            [o layerDidTouched:touch];
        }];
    }
    return YES;
}
// convenience methods which take a UITouch instead of CGPoint

#ifdef __CC_PLATFORM_IOS

/*----------------------------------------------------------------------------
 Method:      <#method name#>   <#description#>
 -----------------------------------------------------------------------------*/
- (CGPoint)convertTouchToNodeSpace:(UITouch *)touch
{
	CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
	return [self convertToNodeSpace:point];
}

/*----------------------------------------------------------------------------
 Method:      <#method name#>   <#description#>
 -----------------------------------------------------------------------------*/
- (CGPoint)convertTouchToNodeSpaceAR:(UITouch *)touch
{
	CGPoint point = [touch locationInView: [touch view]];
	point = [[CCDirector sharedDirector] convertToGL: point];
	return [self convertToNodeSpaceAR:point];
}

-(CGPoint)distanceXYWithFlappi:(CGPoint)pos{
    return ccp(abs(pos.x - _flap.pos_x), abs(pos.y - _flap.pos_y));
}
#endif // __CC_PLATFORM_IOS
@end

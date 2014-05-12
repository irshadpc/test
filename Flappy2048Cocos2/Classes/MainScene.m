
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
#import "GameOverLayer.h"

@interface MainScene()<ColumnLayerDelegate, MenuLayerDelegate, GameOverMenuDelegate>

@end

@implementation MainScene{
    //------------------------------
    MenuLayer *_starMenuLayer;
    BackgroundLayer *_backgroundLayer;
    GameOverLayer *_gameOverLayer;
    CCLayer *_mainLayer;
    //------------------------------
    NSMutableArray *_sprites;
    NSMutableArray *_allSquare;
    //------------------------------
    Flappie *_flap;
    ColumnLayer *_col;
    ColumnLayer *_colBuffer;
    float _distance2Col;
    //------------------------------
    //Resrouce bacthnode
    CCSpriteBatchNode *_batchNode;
    //------------------------------
    BOOL _impacted;
    BOOL _checkCol;
}

+(CCScene*)scene
{
    CCScene *scene = [CCScene node];
    MainScene *mainScene = [MainScene node];
    [scene addChild:mainScene];
    return scene;
}

-(id)init
{
    if(self = [super init])
    {
        _batchNode = [CCSpriteBatchNode batchNodeWithFile:@"flappy2048.pvr"];
        [self addChild:_batchNode];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flappy2048.plist"];
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        _backgroundLayer = [[[BackgroundLayer alloc] initWithParentLayer:self] autorelease];
        _backgroundLayer.anchorPoint = ccp(0, 0);
        [self addChild:_backgroundLayer];
        [self initData];
        [self initFlappi];
        [self initCol];
        
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(didImpactGround:) name:@"nt_impact_ground" object:nil];
        [game setGameState:GAME_BEGIN];
        [self scheduleUpdate];
        _impacted = NO;
        _checkCol = YES;
    }
    return self;
}

-(void)didImpactGround:(NSNotification*)noti
{
}

//==========================================================================================//
// INIT
//==========================================================================================//
-(void)initData
{
    [game setGameState:GAME_BEGIN];
    [self initGameMenuLayer];
    [self initGameOverMenuLayer];
    [self addChild:_starMenuLayer z:10];
}

-(void)initGameMenuLayer
{
    _starMenuLayer = [[MenuLayer alloc] init];
    _starMenuLayer.anchorPoint = ccp(0.5, 0);
    _starMenuLayer.contentSize = CGSizeMake(viewSize.width, viewSize.height);
    _starMenuLayer._delegate = self;
}

-(void)initGameOverMenuLayer
{
    _gameOverLayer = [[GameOverLayer alloc] init];
    _gameOverLayer.anchorPoint = ccp(0.5, 0);
    _gameOverLayer.contentSize = CGSizeMake(viewSize.width, viewSize.height);
    _gameOverLayer.delegate = self;
}

-(void)initFlappi{
    _sprites = [[NSMutableArray alloc] init];
    _flap = [[Flappie alloc] initWithGameLayer:self];
    [_flap updatePosition:ccp(self.contentSize.width/4, 3*self.contentSize.height/5)];
    // add to screen
    [_flap putOn];
    // add to array to handler in game logic
    [_sprites addObject:_flap];
}

-(void)initCol
{
    _distance2Col = viewSize.width - 50;
    _col = [[ColumnLayer alloc] initBlocksWitnValue:1 parentLayer:self];
    _col._columIndex = 0;
    _colBuffer = [[ColumnLayer alloc] initBlocksWitnValue:2 parentLayer:self];
    _colBuffer._columIndex = 1;
    _col.anchorPoint = ccp(0.5, 0);
    _colBuffer.anchorPoint = ccp(0.5, 0);
    [_col setDelegate:self];
    [_colBuffer setDelegate:self];
    
    CCSprite* groundTemp = [CCSprite spriteWithFile:@"ground.png"];
    Square* sqtemp = [[Square alloc] initWithGameLayer:self];
    [_col updatePosition:ccp(viewSize.width + [sqtemp width]*2, groundTemp.contentSize.height)];
    [_colBuffer updatePosition:ccp(_col.position.x + _col.contentSize.width /2 + _distance2Col, groundTemp.contentSize.height)];
    
    [self addChild:_col z:1];
    [self addChild:_colBuffer z:1];
    [_sprites addObject:_col];
    [_sprites addObject:_colBuffer];
}


#pragma mark ColumnDelegate

-(void)impactWithPos:(CGPoint)pos
{
    DLog(@"impact");
    [_flap updatePosition:pos];
    [_flap setFlappieStatus:SLIDING];
    id zoomIn = [CCScaleTo actionWithDuration:0.2 scale:1.5];
    id zoomOut =[CCScaleTo actionWithDuration:0.2 scale:1.0];
    id acitonSequene = [CCSequence actionOne:zoomIn two:zoomOut];
    _flap.sprite.rotation = 0;
    [_flap.sprite stopAllActions];
    [_flap.sprite runAction:[CCRepeat actionWithAction:acitonSequene times:1]];
}

-(void)columnFlappieDidOut
{
    [_flap setFlappieStatus:FLAPPYNG];
}

-(void)impactDone
{
    DLog(@"impact done");
    _impacted = NO;
    _checkCol = !_checkCol;
    [_flap setFlappieStatus:FLAPPYNG];
}

#pragma mark MenuDelegate
-(void)gameMenuDidTouchStart
{
    [game setGameState:GAME_RUNNING];
    [_starMenuLayer removeFromParentAndCleanup:YES];
    [_flap setFlappieStatus:FLAPPYNG];
    [_col activate];
    [_colBuffer activate];
}

-(void)gameOverDidTouchPlayAgain
{
    [_gameOverLayer removeAllChildrenWithCleanup:YES];
    DLog(@"Play again");
}

-(void)gameOverDidTouchShareFacebook
{
    DLog(@"Share facebook");
}
#pragma mark Game Timer Update
-(void)update:(ccTime)delta
{
    
    if([_sprites count] >0)
    {
        [_sprites enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            GameObject* o = (GameObject *)obj;
            [o update:delta];
        }];
    }
    if([game gameState] != GAME_OVER){
        [self checkImpact];
    }
}

-(void)checkImpact{
    CGPoint pos;
    CGPoint flapPos;
    float disX;
    float disY;
    
    if(_checkCol){
        pos = ccp(_col.position.x, _col.y_pos + _col.position.y);
        flapPos = ccp(_flap.pos_x, _flap.pos_y);
        disX = flapPos.x + _flap.sprite.contentSize.width/2 - pos.x;
        disY = flapPos.y - _flap.sprite.contentSize.height - pos.y;
        if(abs(disX)<_flap.sprite.contentSize.width  && abs(disY)<_flap.sprite.contentSize.width && _impacted == NO)
        {
            _impacted = YES;
            [self impactWithPos:ccp(_flap.pos_x, _col.y_pos + _col.position.y + _flap.sprite.contentSize.height)];
            return;
        }
        else if(_impacted==YES && disX > _flap.sprite.contentSize.width)
        {
            _impacted = NO;
            [self impactDone];
            [_flap updateNumber:_col._value];
            return;
        }
        if(abs(disX)<_flap.sprite.contentSize.width && _impacted==NO){
            [self overTheGame];
            return;
        }
        
    }
    else{
        flapPos = ccp(_flap.pos_x, _flap.pos_y);
        pos = ccp(_colBuffer.position.x, _colBuffer.y_pos + _colBuffer.position.y);
        disX = flapPos.x + _flap.sprite.contentSize.width/2 - pos.x;
        disY = flapPos.y - _flap.sprite.contentSize.height - pos.y;
        if(abs(disX)<_flap.sprite.contentSize.width  && abs(disY)<_flap.sprite.contentSize.width && _impacted==NO)
        {
            _impacted = YES;
            [self impactWithPos:ccp(_flap.pos_x, _colBuffer.y_pos + _colBuffer.position.y + _flap.sprite.contentSize.height)];
            return;
        }
        else if(disX > _flap.sprite.contentSize.width && _impacted==YES)
        {
            _impacted = NO;
            [self impactDone];
            [_flap updateNumber:_colBuffer._value];
            return;
        }
        if(abs(disX)<_flap.sprite.contentSize.width && _impacted==NO){
            [self overTheGame];
            return;
        }
    }
    
}

-(void)overTheGame
{
    [game setGameState:GAME_OVER];
    [_col deActivate];
    [_colBuffer deActivate];
    [_flap setFlappieStatus:DIE];
    if(![self getChildByTag:99]){
        [self addChild:_gameOverLayer z:10 tag:99];
    }else{
        DLog(@"");
    }
}

#pragma mark touch handler
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
    return ccp(pos.x - _flap.pos_x, pos.y - _flap.pos_y);
}
-(CGPoint)posFlappi{
    return _flap.sprite.position;
}
#endif // __CC_PLATFORM_IOS
@end

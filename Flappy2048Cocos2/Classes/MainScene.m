
//
//  MainScene.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright (c) 2014 catcher. All rights reserved.
//
#import <AudioToolbox/AudioServices.h>
#import "MainScene.h"
#import "Flappie.h"
#import "Square.h"
#import "MenuLayer.h"
#import "BackgroundLayer.h"
#import "ColumnLayer.h"
#import "GameOverLayer.h"
#import "HUDLayer.h"
#import "Game.h"
#import "GAI.h"
#import "SimpleAudioEngine.h"
#import "UIColor+Cocos.h"


@interface MainScene()<ColumnLayerDelegate, MenuLayerDelegate, GameOverMenuDelegate>

@end

@implementation MainScene{
    //------------------------------
    MenuLayer *_starMenuLayer;
    BackgroundLayer *_backgroundLayer;
    GameOverLayer *_gameOverLayer;
    HUDLayer *_hudLayer;
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
    BOOL _soundOn;
    
    CCLayerColor *colorLayer;
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
        [self addChild:_backgroundLayer z:0];
        [self initData];
        [self initFlappi];
        [self initCol];
        
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(didImpactGround:) name:@"nt_impact_ground" object:nil];
        [game setGameState:GAME_BEGIN];
        [self scheduleUpdate];
        _impacted = NO;
        _checkCol = YES;
        _soundOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"game_sound"];
    }
    return self;
}

-(void)didImpactGround:(NSNotification*)noti
{
    [self overTheGame];
}

//==========================================================================================//
// INIT
//==========================================================================================//
-(void)initData
{
    [game setGameState:GAME_BEGIN];
    [self initHudLayer];
    [self initGameMenuLayer];
    [self initGameOverMenuLayer];
    [self addChild:_starMenuLayer z:10];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_wing.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_hit.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_die.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_swooshing.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"sfx_pass.mp3"];

}

-(void)initHudLayer{
    _hudLayer = [[HUDLayer alloc] init];
    _hudLayer.anchorPoint = ccp(0.5, 0.5);
    _hudLayer.contentSize = viewSize;
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
    colorLayer = [CCLayerColor layerWithColor:ccc4(255, 0, 0, 10) width:viewSize.width height:viewSize.height];
}

-(void)initFlappi{
    _sprites = [[NSMutableArray alloc] init];
    _flap = [[Flappie alloc] initWithGameLayer:self];
    [_flap updatePosition:ccp(self.contentSize.width/4, 3*self.contentSize.height/5)];
    [_flap setColor:[UIColor colorWithHexString:@"#eeeeee"]];
    [_flap putOn];
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
    [_hudLayer increseScore];
    [_flap updatePosition:pos];
    [_flap setFlappieStatus:SLIDING];
    id zoomIn = [CCScaleTo actionWithDuration:0.2 scale:1.5];
    id zoomOut =[CCScaleTo actionWithDuration:0.2 scale:1.0];
    id acitonSequene = [CCSequence actionOne:zoomIn two:zoomOut];
    _flap.sprite.rotation = 0;
    [_flap.sprite stopAllActions];
    [_flap.sprite runAction:[CCRepeat actionWithAction:acitonSequene times:1]];
    
    if([game soundOn])
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_pass.mp3"];
}

-(void)columnFlappieDidOut
{
    [_flap setFlappieStatus:FLAPPYNG];
}

-(void)impactDone
{
    _impacted = NO;
    _checkCol = !_checkCol;
    [_flap setFlappieStatus:FLAPPYNG];
}

-(void)overTheGame
{
    [game setGameState:GAME_OVER];
    if([game soundOn])
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_hit.caf"];
        [[SimpleAudioEngine sharedEngine] playEffect:@"sfx_die.caf"];
    }
    [_col deActivate];
    [_colBuffer deActivate];
    [_flap setFlappieStatus:DIE];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    id rotateLeft = [CCRotateTo actionWithDuration:0.01 angle:5];
    id rotateBackLeft = [CCRotateTo actionWithDuration:0.01 angle:-5];
    id rotateRight = [CCRotateTo actionWithDuration:0.01 angle:-5];
    id rotateBackRight = [CCRotateTo actionWithDuration:0.01 angle:5];
    id rotaterollback = [CCRotateTo actionWithDuration:0.01 angle:0];
    id se = [CCSequence actions:rotateLeft, rotateBackLeft, rotateRight, rotateBackRight,rotaterollback, nil];
    [self runAction:[CCRepeat actionWithAction:se times:3]];
    
    if(![self getChildByTag:99]){
        [_gameOverLayer reloadBestScore];
        [self addChild:_gameOverLayer z:10 tag:99];
    }else{
    }
}

-(void)removeRedLayer{
    [colorLayer removeFromParent];
}
#pragma mark MenuDelegate
-(void)gameMenuDidTouchStart
{
    [game setGameState:GAME_RUNNING];
    [_starMenuLayer removeFromParentAndCleanup:YES];
    [_flap setFlappieStatus:FLAPPYNG];
    _flap.vel_y = 000;
    [_col activate];
    [_colBuffer activate];
    [self addChild:_hudLayer z:10];
    [game trackNewGame];
}

-(void)gameOverDidTouchPlayAgain
{
    [game setGameState:GAME_RUNNING];
    [game trackPlayAgain];
    [_gameOverLayer removeFromParentAndCleanup:NO];

    [_flap updatePosition:ccp(self.contentSize.width/4, 3*self.contentSize.height/5)];
    [_flap setFlappieStatus:FLAPPYNG];
    [_flap updateNumber:1];
    [_flap setColor:[UIColor colorWithHexString:@"#eeeeee"]];
    _flap.vel_y = 000;
    
    CCSprite* groundTemp = [CCSprite spriteWithFile:@"ground.png"];
    Square* sqtemp = [[Square alloc] initWithGameLayer:self];
    [_col updatePosition:ccp(viewSize.width + [sqtemp width]*2, groundTemp.contentSize.height)];
    [_colBuffer updatePosition:ccp(_col.position.x + _col.contentSize.width /2 + _distance2Col, groundTemp.contentSize.height)];
    [_col resetWithValue:1];
    [_colBuffer resetWithValue:2];
    
    _impacted = NO;
    _checkCol = YES;
    
    [_col activate];
    [_colBuffer activate];
    
    [_hudLayer resetScore];
}


-(void)gameOverDidTouchShareFacebook
{
//    [_gameOverLayer removeFromParent];
    [game trackShareFacebook];
    [game shareFb];
    
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
            [_flap setColor:[_col getTargetBlockColor]];
            [_flap updateNumber:_col._value*2];
            [self impactWithPos:ccp(_flap.pos_x, _col.y_pos + _col.position.y + _flap.sprite.contentSize.height)];
            return;
        }
        else if(_impacted==YES && disX > _flap.sprite.contentSize.width)
        {
            _impacted = NO;
            [self impactDone];
            return;
        }else if(disX==0 && _impacted){
            [_col removeTargetBlock];
        }
        if (_impacted && _col._scrollEnable){
            [_flap updatePosition:ccp(_flap.pos_x, _col.y_pos + _col.position.y + _flap.sprite.contentSize.height)];
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
            [_flap setColor:[_colBuffer getTargetBlockColor]];
            [_flap updateNumber:_colBuffer._value*2];
            [self impactWithPos:ccp(_flap.pos_x, _colBuffer.y_pos + _colBuffer.position.y + _flap.sprite.contentSize.height)];
            return;
        }
        else if(disX > _flap.sprite.contentSize.width && _impacted==YES)
        {
            _impacted = NO;
            [self impactDone];
            
            return;
        }else if(disX==0 && _impacted){
            [_colBuffer removeTargetBlock];
        }
        if (_impacted && _colBuffer._scrollEnable){
            [_flap updatePosition:ccp(_flap.pos_x, _colBuffer.y_pos + _colBuffer.position.y + _flap.sprite.contentSize.height)];
        }
        if(abs(disX)<_flap.sprite.contentSize.width && _impacted==NO){
            [self overTheGame];
            return;
        }
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

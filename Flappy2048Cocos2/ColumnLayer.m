//
//  ColumnLayer.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "ColumnLayer.h"
#import "MainScene.h"
#import "NSMutableArray+Shuffling.h"

#define NUM_START_SCROLL 32

@implementation ColumnLayer
{
    NSMutableArray *valuesArray;
    NSMutableArray *squareArray;
}

@synthesize _value, _columIndex, delegate, _targetBlock, y_pos, _scrollable;

-(id)init
{
    if(self = [super init]){
        _indexOfTarget = -1;
        _impacted = NO;
        y_pos = 0;
        _scrollable = NO;
    }
    return self;
}

-(id)initBlocksWitnValue:(NSInteger)value parentLayer:(CCLayer*)aLayer
{
    if(self = [super init]){
        valuesArray = [[NSMutableArray alloc] init];
        squareArray = [[NSMutableArray alloc] init];
        _value = value; // 1,2 4 8 16 ....
        _parentLayer = aLayer;
        _targetBlock = [[Square alloc] initWithGameLayer:self];
        [_targetBlock setNumber:value];
        float size = _targetBlock.sprite.contentSize.width;
        self.anchorPoint = ccp(0.5, 0);
        self.contentSize = CGSizeMake(size, aLayer.contentSize.height);
        pos_x = aLayer.contentSize.width + [_targetBlock width];
        pos_y = self.position.y;
        [self loadColumn:size];
        activated = NO;
    }
    return self;
}

-(void)loadColumn:(float)blockSize
{
    int count = self.contentSize.height / blockSize +1;
    _indexOfTarget =  1 + arc4random()%(count-4);
    
    float y = 0;
    for (int i=0; i< count; i++)
    {
        y = i*blockSize;
        if(i ==_indexOfTarget)
        {
            _targetBlock.sprite.anchorPoint = ccp(0.5, 0);
            [_targetBlock updatePosition:ccp(0, y)];
            y_pos = y;
            [_targetBlock putOn];
            [squareArray addObject:_targetBlock];
            [valuesArray addObject:@(_value)];
        }
        else
        {
            Square *sq = [[Square alloc] initWithGameLayer:self];
            sq.sprite.anchorPoint = ccp(0.5, 0);
            [sq updatePosition:ccp(0, y)];
            int randomPow = 2 + arc4random() % count;
            long randomValue = pow(2, randomPow);
            [sq setNumber:randomValue];
            [sq putOn];
            [squareArray addObject:sq];
            [valuesArray addObject:@(randomValue)];
        }
    }
    highest_y = ((Square*)[squareArray lastObject])._y;
}

-(void)updateAllSquaresWithUpperValue
{
    _value*=4;
    if(_value >= NUM_START_SCROLL){
        _scrollable = YES;
    }
    
    for (Square *sq in squareArray) {
        [sq setNumberWithOldColor:sq._valueNumber*4];
    }
    
}

-(void)activate{
    activated = YES;
}
-(void)deActivate{
    activated = NO;
}

-(void)layerDidTouched:(UITouch*)touch{
    
}

-(void)updatePosition:(CGPoint)pos{
    pos_x = pos.x;
    pos_y = pos.y;
    [self setPosition:ccp(pos_x, pos_y)];
}

-(void)update:(ccTime)delta{
    if(!activated) return;
    // update pos_x, pos_y
    pos_x -= 2;
    if(pos_x < -(viewSize.width - 50))
    {
        // reset value with the higher pow 2*2
        pos_x = _parentLayer.position.x + _parentLayer.contentSize.width + self.contentSize.width/2;
        [self updateAllSquaresWithUpperValue];
        [_targetBlock.sprite setVisible:YES];
    }
    // update position
    [self setPosition:ccp(pos_x, pos_y)];
    if(_scrollable){
        for (Square* sq in squareArray) {
            if(sq != _targetBlock){
                float y = sq._y-0.4;
                if (y < -[sq height]) {
                    y = highest_y ;
                }
                [sq updatePosition:ccp(sq._x, y)];
            }else{
                y_pos = sq._y-0.4;
                if (y_pos < -[sq height]) {
                    y_pos = highest_y;
                }
                [sq updatePosition:ccp(sq._x, y_pos)];
            }
        }
    }
}

-(void)removeTargetBlock
{
    [_targetBlock.sprite setVisible:NO];
}
-(void)resetWithValue:(long)number{
    [_targetBlock.sprite setVisible:YES];
    _value = number;
    int count = self.contentSize.height / _targetBlock.sprite.contentSize.height +1;
    for (int i=0; i< count; i++){
        if(i == _indexOfTarget){
            [_targetBlock setNumber:_value];
        }else{
            Square * sq   = [squareArray objectAtIndex:i];
            int randomPow = 2 + arc4random() % count;
            long randomValue = pow(2, randomPow);
            [sq setNumber:randomValue];
        }
    }
    _scrollable = NO;
}
@end


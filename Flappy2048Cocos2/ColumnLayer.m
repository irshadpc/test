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

#define NUM_START_SCROLL 2048

@implementation ColumnLayer
{
    __unsafe_unretained NSMutableArray *valuesArray;
    __unsafe_unretained NSMutableArray *squareArray;
}

@synthesize _value, _columIndex, delegate, _targetBlock, y_pos, _scrollEnable;

-(id)init
{
    if(self = [super init]){
        _indexOfTarget = -1;
        _impacted = NO;
        y_pos = 0;
        _scrollEnable = NO;
        level = 0;
        _scrollStatus = SCROLL_NONE;
    }
    return self;
}

-(id)initBlocksWitnValue:(NSInteger)value parentLayer:(CCLayer*)aLayer
{
    if(self = [super init]){
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
    squareArray = [[NSMutableArray alloc] initWithCapacity:count];
    valuesArray = [[NSMutableArray alloc] initWithCapacity:count];
    [squareArray removeAllObjects];
    [valuesArray removeAllObjects];
    [valuesArray addObjectsFromArray:[self generateRandomLevelAround:1 count:count]];
    _indexOfTarget =  1 + arc4random()%(count-4);
    int randomIndex = arc4random_uniform(count - 4) + 2;
    int levelOfValue = log2(_value);
    if([valuesArray containsObject:@(levelOfValue)])
    {
        _indexOfTarget = [valuesArray indexOfObject:@(levelOfValue)];
        if(_indexOfTarget < 1 || _indexOfTarget > count - 2){
            [valuesArray exchangeObjectAtIndex:_indexOfTarget withObjectAtIndex:randomIndex];
            _indexOfTarget = randomIndex;
        }
    }
    else{
        [valuesArray replaceObjectAtIndex:(valuesArray.count-1) withObject:@(_value)];
        [valuesArray exchangeObjectAtIndex:(valuesArray.count-1) withObjectAtIndex:randomIndex];
        _indexOfTarget = randomIndex;
    }
    float y = 0;
    int i = 0;
    while (squareArray.count < count)
    {
        if(i ==_indexOfTarget)
        {
            y_pos = y;
            _targetBlock.sprite.anchorPoint = ccp(0.5, 0);
            [_targetBlock updatePosition:ccp(0, y)];
            [_targetBlock putOn];
            [squareArray addObject:_targetBlock];
        }
        else
        {
            int val = pow(2,[[valuesArray objectAtIndex:i] intValue]);
            Square *sq = [[Square alloc] initWithGameLayer:self];
            sq.sprite.anchorPoint = ccp(0.5, 0);
            [sq updatePosition:ccp(0, y)];
            [sq setNumber:val];
            [sq putOn];
            
            [squareArray addObject:sq];
        }
        y = i*blockSize;
        i++;
    }
    
    highest_y = ((Square*)[squareArray lastObject])._y;
    lowest_y = ((Square*)[squareArray objectAtIndex:0])._y;
}

-(void)resetWithValue:(unsigned long)number
{
    [self removeAllChildrenWithCleanup:YES];
    _targetBlock = [[Square alloc] initWithGameLayer:self];
    [_targetBlock setNumber:number];
    [_targetBlock.sprite setVisible:YES];
    _value = number;
    level = log2(_value);
    _scrollEnable = NO;
    _scrollStatus = SCROLL_NONE;
    int count = self.contentSize.height / _targetBlock.sprite.contentSize.width +1;
    [squareArray removeAllObjects];
    [valuesArray removeAllObjects];
    [valuesArray addObjectsFromArray:[self generateRandomLevelAround:1 count:count]];

    _indexOfTarget =  1 + arc4random()%(count-4);
    int randomIndex = arc4random_uniform(count - 4) + 2;
    int levelOfValue = log2(_value);
    if([valuesArray containsObject:@(levelOfValue)])
    {
        _indexOfTarget = [valuesArray indexOfObject:@(levelOfValue)];
        if(_indexOfTarget < 1 || _indexOfTarget > count - 2){
            [valuesArray exchangeObjectAtIndex:_indexOfTarget withObjectAtIndex:randomIndex];
            _indexOfTarget = randomIndex;
        }
    }
    else{
        [valuesArray replaceObjectAtIndex:(valuesArray.count-1) withObject:@(_value)];
        [valuesArray exchangeObjectAtIndex:(valuesArray.count-1) withObjectAtIndex:randomIndex];
        _indexOfTarget = randomIndex;
    }
    float y = 0;
    int i = 0;
    while (squareArray.count < valuesArray.count)
    {
        if(i ==_indexOfTarget)
        {
            y_pos = y;
            _targetBlock.sprite.anchorPoint = ccp(0.5, 0);
            [_targetBlock updatePosition:ccp(0, y)];
            [_targetBlock putOn];
            [squareArray addObject:_targetBlock];
        }
        else
        {
            int val = pow(2,[[valuesArray objectAtIndex:i] intValue]);
            Square *sq = [[Square alloc] initWithGameLayer:self];
            sq.sprite.anchorPoint = ccp(0.5, 0);
            [sq updatePosition:ccp(0, y)];
            [sq setNumber:val];
            [sq putOn];
            [squareArray addObject:sq];
        }
        y = i*_targetBlock.sprite.contentSize.width;
        i++;
    }
    highest_y = ((Square*)[squareArray lastObject])._y;
    lowest_y = ((Square*)[squareArray objectAtIndex:0])._y;
    
}

-(void)updateAllSquaresWithUpperValue
{
    level +=2;
    _value *= 4;
    NSArray * generatedNumArray =  [self generateRandomLevelAround:log2(_value) count:squareArray.count];
    if(_value >= NUM_START_SCROLL){
        _scrollEnable = YES;
    }
    int count = squareArray.count;
    int randomIndex = arc4random_uniform(count - 4) + 2;
    Square *sq = [squareArray objectAtIndex:randomIndex];
    CGPoint ranPos = ccp(sq._x, sq._y);
    [sq updatePosition:ccp(_targetBlock._x, _targetBlock._y)];
    [_targetBlock updatePosition:ranPos];
    y_pos = ranPos.y;
    for (int i = 0 ; i < squareArray.count; i++)
    {
        Square *sq = [squareArray objectAtIndex:i];
        if(sq != _targetBlock)
        {
            int alevel = [[generatedNumArray objectAtIndex:i] intValue];
            [sq setNumberWithOldColor:pow(2, alevel)];
        }else
        {
            [_targetBlock setNumberWithOldColor:_targetBlock._valueNumber*4];
        }
    }
    
}

-(UIColor*)getTargetBlockColor{
    return [_targetBlock color];
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

-(void)update:(ccTime)delta
{
    if(!activated) return;
    pos_x -= 2;
    if(pos_x < -(viewSize.width - 50))
    {
        pos_x = _parentLayer.position.x + _parentLayer.contentSize.width + self.contentSize.width/2;
        [self updateAllSquaresWithUpperValue];
        [_targetBlock.sprite setVisible:YES];
    }
    // update position
    [self setPosition:ccp(pos_x, pos_y)];
    if(_scrollEnable)
    {
        switch (_scrollStatus) {
            case SCROLL_NONE:
                _scrollStatus = SCROLL_DOWN;
                break;
            case SCROLL_DOWN:
            {
                    [self scrollAllDown];
                    if(y_pos < lowest_y + 60){
                        _scrollStatus = SCROOL_UP;
                        DLog(@"Swicth scroll from down to up");
                    }
            }
                break;
            case SCROOL_UP:
            {
                [self scrollAllUp];
                if(y_pos > highest_y - 80){
                    _scrollStatus = SCROLL_DOWN;
                    DLog(@"Swicth scroll from up to down");
                }
            }
                break;
        }
    }
}

-(void)scrollAllDown
{
    for (Square* sq in squareArray)
    {
        float y = sq._y-0.4;
        y = (y < -[sq height]) ? highest_y : y;
        if(sq == _targetBlock) y_pos = y;
        [sq updatePosition:ccp(sq._x, y)];
    }
}
-(void)scrollAllUp
{
    for (Square* sq in squareArray)
    {
        float y = sq._y + 0.4;
        y = (y > highest_y) ? -[sq height] : y;
        if(sq == _targetBlock) y_pos = y;
        [sq updatePosition:ccp(sq._x, y)];
    }
}

-(void)removeTargetBlock
{
    [_targetBlock.sprite setVisible:NO];
}


-(NSArray*)generateRandomLevelAround:(int)aLevel count:(int)count{
    NSMutableArray *originalArray = [[NSMutableArray alloc] initWithCapacity:count];
    int min = 1;
    int generatedNum = aLevel;
    while (originalArray.count < count) {
        if(aLevel > 4){
            min = aLevel - 3;
        }
        generatedNum = arc4random_uniform(aLevel + count - min + 1) + min;
        NSNumber *num = @(generatedNum);
        if(![originalArray containsObject:num] && generatedNum!= aLevel){
            [originalArray addObject:num];
        }
    }
    [originalArray shuffle];
    return originalArray;
}

@end


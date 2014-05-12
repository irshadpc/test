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

@implementation ColumnLayer

@synthesize _value, _columIndex, delegate, _targetBLock, y_pos;

-(id)init
{
    if(self = [super init]){
        _indexOfTarget = -1;
        _impacted = NO;
        x_pos = 0;
        y_pos = 0;
    }
    return self;
}

-(id)initBlocksWitnValue:(NSInteger)value parentLayer:(CCLayer*)aLayer
{
    if(self = [super init]){
        _value = value; // 1,2 4 8 16 ....
        _squareArray = [[NSMutableArray  alloc] init];
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
    int count = self.contentSize.height / blockSize;
    _indexOfTarget =  1 + arc4random()%(count-1);
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
        }

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
        pos_x = _parentLayer.position.x + _parentLayer.contentSize.width + self.contentSize.width/2;
    }
    // update position
    [self setPosition:ccp(pos_x, pos_y)];
}


-(void)setArrayValue:(NSArray *)values{
    if(!_valueArray)
    {
        _valueArray = [[NSMutableArray alloc] initWithArray:values];
    }else{
        [_valueArray removeAllObjects];
        [_valueArray addObjectsFromArray:values];
    }
    [_valueArray shuffle];
    
    int count = [_squareArray count];
    for (int i=0; i<count; i++) {
        Square *s = [_squareArray objectAtIndex:i];
        [s setNumber:(long)[_valueArray objectAtIndex:i]];
    }
}

@end


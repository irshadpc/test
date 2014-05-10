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
@synthesize _value, _delegate = delegate, _columIndex;
-(id)init{
    if(self = [super init]){
        
        
    }
    return self;
}

-(id)initBlocksWitnValue:(NSInteger)value parentLayer:(CCLayer*)aLayer
{
    if(self = [super init]){
        _value = value;
        _squareArray = [[NSMutableArray  alloc] init];
        _parentLayer = aLayer;
        Square *sq = [[Square alloc] initWithGameLayer:self];
        float size = sq.sprite.contentSize.width;
        self.anchorPoint = ccp(0.5, 0);
        self.contentSize = CGSizeMake(size, aLayer.contentSize.height);
        pos_x = aLayer.contentSize.width + [sq width];
        pos_y = self.position.y;
        [self loadColumn:size];
        activated = NO;

    }
    return self;
}

-(void)loadColumn:(float)blockSize{
    int count = self.contentSize.height / blockSize;
    float y = 0;
    for (int i=0; i< count; i++)
    {
        y = i*blockSize;
        Square *sq = [[Square alloc] initWithGameLayer:self];
        sq.sprite.anchorPoint = ccp(0.5, 0);
        [sq updatePosition:ccp(0, y)];
        [sq setNumber:_value];
        [sq putOn];
    }
}

-(void)activate{
    activated = YES;
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
    pos_x -= 2;
    if(pos_x < -(viewSize.width - 50)){
        pos_x = _parentLayer.position.x + _parentLayer.contentSize.width + self.contentSize.width/2;
    }
    if([self checkParentFlappyImpact]){

    }
    [self setPosition:ccp(pos_x, pos_y)];
}
-(BOOL)checkParentFlappyImpact{
    CGPoint disXY = [(MainScene*)_parentLayer distanceXYWithFlappi:self.position];
    if (disXY.x < 30)
    {
        return YES;
    }else{
        return NO;
    }
}

-(void)mul4{
    _value = _value *2*2;
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


//
//  ColumnLayer.h
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Square.h"

@protocol ColumnLayerDelegate;
@interface ColumnLayer : CCLayer {
    NSMutableArray *_squareArray;
    NSMutableArray *_valueArray;
    NSInteger _value;
    CCLayer *_parentLayer;
    float pos_x;
    float pos_y;
    id<ColumnLayerDelegate> _delegate;
    int _columIndex;
    BOOL activated;
}


@property (assign, nonatomic) NSInteger _value;
@property (assign, nonatomic) int _columIndex;
@property (assign, nonatomic) id<ColumnLayerDelegate> _delegate;
-(void)activate;
-(void)updatePosition:(CGPoint)pos;
-(id)initBlocksWitnValue:(NSInteger)value parentLayer:(CCLayer*)aLayer;
-(void)moveToStatOfParent;
-(void)mul4;
-(void)layerDidTouched:(UITouch*)touch;
-(void)setArrayValue:(NSArray*)values;
@end

@protocol ColumnLayerDelegate
@required
-(void)columnDidOutOffScreen:(int)index;
@end

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
    long _value;
    CCLayer *_parentLayer;
    float pos_x;
    float pos_y;
    int _columIndex;
    BOOL activated;
    int _indexOfTarget;
    BOOL _impacted;
    id<ColumnLayerDelegate> delegate;
    Square *_targetBlock;
    float x_pos;
    float y_pos;
    
    BOOL _scrollable;
}


@property (assign, nonatomic) long _value;
@property (assign, nonatomic) int _columIndex;
@property (assign, nonatomic) id<ColumnLayerDelegate> delegate;
@property (strong, nonatomic) Square *_targetBlock;
@property (assign, nonatomic) float y_pos;
-(id)initBlocksWitnValue:(NSInteger)value parentLayer:(CCLayer*)aLayer;
-(void)activate;
-(void)deActivate;
-(void)updatePosition:(CGPoint)pos;
-(void)layerDidTouched:(UITouch*)touch;
-(void)removeTargetBlock;
@end

@protocol ColumnLayerDelegate<NSObject>
//@required
-(void)columnDidImpactFlappie:(NSNumber*)pos_y;
-(void)columnFlappieDidOut;
@end

//
//  Square.m
//  Flappy2048Cocos2
//
//  Created by namnh9 on 5/9/14.
//  Copyright 2014 catcher. All rights reserved.
//

#import "Square.h"
#import "Game.h"
#import "UIColor+RTTFromHex.h"
#import "UIColor+Cocos.h"

//var text_colors = ['606060', '606060', '606060', 'ffffff'];
//var tile_colors = ['eeeeee', 'eae8e4', 'ede0c8', 'f2b179', 'f59563', 'f67c5f', 'f65e3b', 'edcf72', 'edcc61', 'edc850', 'edc53f', 'edc53f', '3c3a32'];
//var tile_colors_2 = ['4c4c4c', '5c5c5c', '4c5c6c', '4c4c7c', '3c3c6c', '2c2c5c', '2c3c4c', '2c4c3c', '2c5c2c', '3c3a32'];// 'c050c0', '9050ff', '5090ff', '60b060', '40b0b0', 'b0b040', '3c3a32'];

@implementation Square
{
    CCSprite *_frame;
    CCSprite *_content;
    CCLabelTTF *_valueLabel;
}
@synthesize _x, _y, _valueNumber, _tileColor, _tileColor2, _textColor, c;

-(id)initWithGameLayer:(CCLayer *)aLayer
{
    if(self = [super initWithGameLayer:aLayer])
    {
        _frame = [CCSprite spriteWithSpriteFrameName:@"block-frame"];
        _content = [CCSprite spriteWithSpriteFrameName:@"block-content"];
        _frame.anchorPoint = ccp(0.5, 0);
        _content.anchorPoint = ccp(0.5, 0);
        sprite = [CCSprite node];
        [sprite addChild:_content];
        [sprite addChild:_frame];
        sprite.contentSize = _frame.contentSize;
        _tileColor = [CCArray new];
        [_tileColor addObjectsFromNSArray:@[@"eeeeee",@"eae8e4",@"ede0c8",@"f2b179",@"f59563",@"f67c5f",@"f65e3b",@"edcf72",@"edcc61",@"edc850",@"edc53f",@"edc53f",@"3c3a32"]];
        _tileColor2 = [CCArray new];
        [_tileColor2 addObjectsFromNSArray:@[@"4c4c4c",@"5c5c5c",@"4c5c6c",@"4c4c7c",@"3c3c6c",@"2c2c5c",@"2c3c4c",@"2c4c3c",@"2c5c2c",@"3c3a32",@"c050c0",@"9050ff",@"5090ff",@"60b060",@"40b0b0",@"b0b040",@"3c3a32"]];
        _textColor = [CCArray new];
        [_textColor addObjectsFromNSArray:@[@"606060",@"606060",@"606060",@"ffffff"]];
    }
    return self;
}

#pragma mark public methods
-(void)setNumber:(long)number
{
    _valueNumber = number;
    if(!_valueLabel)
    {
        _valueLabel = [CCLabelTTF labelWithString:@"Hi" fontName:@"Helvetica" fontSize:40
                                       dimensions:sprite.contentSize
                                       hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeClip];
        _valueLabel.verticalAlignment = kCCVerticalTextAlignmentCenter;
        _valueLabel.color = [[UIColor colorWithHexString:@"#606060"] c3b];
        _valueLabel.anchorPoint = ccp(0.5, 0);
        [_valueLabel setContentSize:sprite.contentSize];
        [sprite addChild:_valueLabel];
    }
    int fontsize = [self calculateFontSizeForString:[NSString stringWithFormat:@"%ld", _valueNumber] fontName:@"Helvetica"];
    _valueLabel.fontSize = fontsize;
    [_valueLabel setString:[NSString stringWithFormat:@"%ld", _valueNumber]];

    [self setColor];
}

-(void)setColor
{
    int log = log2(_valueNumber);
    int tci = log ;
    NSString *colorString;
    if(tci < 0) tci = 0;
    if(tci >= _tileColor.count)
    {
        tci -= _tileColor.count;
        tci %= _tileColor2.count;
        DLog(@"Color2 index : %d", tci);
        colorString = [_tileColor2 objectAtIndex:tci];
    }
    else
    {
        DLog(@"Color index : %d", tci);
        colorString = [_tileColor objectAtIndex:tci];
    }
    
    c = [[UIColor colorWithHexString:[NSString stringWithFormat:@"#%@",colorString]] copy];
    _content.color = [c c3b];
}

-(UIColor*)color{
    int log = log2(_valueNumber);
    int tci = log + 1;
    NSString *colorString;
    if(tci < 0) tci = 0;
    if(tci >= _tileColor.count)
    {
        tci -= _tileColor.count;
        tci %= _tileColor2.count;
        DLog(@"Color2 index : %d", tci);
        colorString = [_tileColor2 objectAtIndex:tci];
    }
    else
    {
        DLog(@"Color index : %d", tci);
        colorString = [_tileColor objectAtIndex:tci];
    }
    
    return [[UIColor colorWithHexString:[NSString stringWithFormat:@"#%@",colorString]] copy];
}

-(void)setNumberWithOldColor:(long)number
{
    _valueNumber = number;
    if(!_valueLabel)
    {
        _valueLabel = [CCLabelTTF labelWithString:@"Hi" fontName:@"Helvetica" fontSize:40
                                       dimensions:sprite.contentSize
                                       hAlignment:kCCTextAlignmentCenter lineBreakMode:kCCLineBreakModeClip];
        _valueLabel.verticalAlignment = kCCVerticalTextAlignmentCenter;
        _valueLabel.color = ccc3(0, 0, 0);
        _valueLabel.anchorPoint = ccp(0.5, 0);
        [_valueLabel setContentSize:sprite.contentSize];
        [sprite addChild:_valueLabel];
    }
    int fontsize = [self calculateFontSizeForString:[NSString stringWithFormat:@"%ld", _valueNumber] fontName:@"Helvetica"];
    _valueLabel.fontSize = fontsize;
    [_valueLabel setString:[NSString stringWithFormat:@"%ld", _valueNumber]];
    
    [self setColor];
    
}

- (int) calculateFontSizeForString:(NSString*)string fontName:(NSString*)usedFontName
{
    int fontSize = 40; // it seems to be the biggest font we can use
    while (--fontSize > 0) {
        CGSize size = [string sizeWithFont:[UIFont fontWithName:usedFontName size:fontSize]];
        if (size.width <= sprite.contentSize.width-10 && size.height <= sprite.contentSize.height -10)
            break;
    }
    
    return fontSize;
}

-(void)updatePosition:(CGPoint)newPoint
{
    _x = newPoint.x;
    _y = newPoint.y;
    [sprite setPosition:newPoint];
}

-(void)moveLeft:(float)deltaX
{
    _x = _x - deltaX;
}
-(float)width{ return sprite.contentSize.width;}
-(float)height{ return sprite.contentSize.height;}
@end

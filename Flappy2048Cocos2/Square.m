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

@implementation Square
{
    CCSprite *_frame;
    CCSprite *_content;
    CCLabelTTF *_valueLabel;
    UIColor* c;
}
@synthesize _x, _y, _valueNumber;

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
//        bgColorDic = @{
//                       @1 : @0xeee4da,
//                       @2 : @0xeee4da,
//                       @4 : @0xede0c8,
//                       @8 : @0xf2b179,
//                       @16 : @0xf59563,
//                       @32 : @0xf67c5f,
//                       @64 : @0xf65e3b,
//                       @128 : @0xedcf72,
//                       @256 : @0xedcc61,
//                       @512 : @0xedc850,
//                       @1024 : @0xedc53f,
//                       @2048 : @0xedc22e
//                       };
//        
//        fgColorDic = @{
//                       @1 : @0x776e65,
//                       @2 : @0x776e65,
//                       @4 : @0x776e65,
//                       @8 : @0xf9f6f2,
//                       @16 : @0xf9f6f2,
//                       @32 : @0xf9f6f2,
//                       @64 : @0xf9f6f2,
//                       @128 : @0xf9f6f2,
//                       @256 : @0xf9f6f2,
//                       @512 : @0xf9f6f2,
//                       @1024 : @0xf9f6f2,
//                       @2048 : @0xf9f6f2
//                       };
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
        _valueLabel.color = ccc3(0, 0, 0);
        _valueLabel.anchorPoint = ccp(0.5, 0);
        [_valueLabel setContentSize:sprite.contentSize];
        [sprite addChild:_valueLabel];
    }
    int fontsize = [self calculateFontSizeForString:[NSString stringWithFormat:@"%ld", _valueNumber] fontName:@"Helvetica"];
    _valueLabel.fontSize = fontsize;
    [_valueLabel setString:[NSString stringWithFormat:@"%ld", _valueNumber]];
    if(!c){
        NSUInteger objColor;
        if(number > 1024)
        {
            objColor = [[game colorMap][@(1024)] unsignedIntegerValue];

        }else{
            objColor = [[game colorMap][@(number)] unsignedIntegerValue];
        }
        c = [UIColor fromHex:objColor];
        [_content setColor:[c c3b]];
    }
    
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

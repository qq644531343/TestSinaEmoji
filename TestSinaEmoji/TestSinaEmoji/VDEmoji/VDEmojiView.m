//
//  VDEmojiView.m
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "VDEmojiView.h"

#define __RGBA(r,g,b,a)           [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface VDEmojiView ()

@property (nonatomic,strong) NSMutableArray *picViewsMArray;

@property (nonatomic,strong) UIScrollView *baseScroll;

@end

@implementation VDEmojiView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        //self.windowLevel = UIWindowLevelAlert;
        [self addView];
        
    }
    return self;
}

-(void)addView
{
    _baseScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    _baseScroll.backgroundColor = __RGBA(0xf1, 0xf1, 0xf1, 1.0f);
    [self addSubview:_baseScroll];
    
    _picViewsMArray = [[NSMutableArray alloc] init];
    
    NSArray *emojies = [[VDEmojiManger sharedVDEmojiManger] getAllEmojies];
    
    for (int i = 0; i < emojies.count; i++) {
        
        VDEmojiModel *model = [emojies objectAtIndex:i];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:model.png];
        icon.tag = i;
        [_baseScroll addSubview:icon];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        icon.userInteractionEnabled = YES;
        [icon addGestureRecognizer:tap];
        
        [self.picViewsMArray addObject:icon];
    }
    
    [self setStyle:VDEmojiViewStyleNormal];
}

/////////////////////////////////////////////////////////////

#pragma mark - tools

-(void)click:(UITapGestureRecognizer *)tap
{
    UIImageView *icon = (UIImageView *)tap.view;
    NSArray *emojies = [[VDEmojiManger sharedVDEmojiManger] getAllEmojies];
    
    if (icon.tag > emojies.count) {
        return;
    }
    
    VDEmojiModel *model = [emojies objectAtIndex:icon.tag];
    
    if (self.delegateEmoji && [self.delegateEmoji respondsToSelector:@selector(vdEmojiView:clickedAtEmoji:)])
    {
        [self.delegateEmoji vdEmojiView:self clickedAtEmoji:model];
    }
}

-(void)setStyle:(VDEmojiViewStyle)style
{
    _style = style;
    
    switch (style) {
        case VDEmojiViewStyleNormal:
        {
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 7; j++) {
                    
                    UIImageView *icon = [self.picViewsMArray objectAtIndex:i*7 + j];
                    
                    
                    icon.frame = CGRectMake(20 + j*(30 + 20), 15+i*(30+15), 30, 30);

                }
            }
            
            break;
        }
        case VDEmojiViewStyleFullScreen:
        {
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - other

-(void)dealloc
{
    self.delegateEmoji = nil;
    self.baseScroll = nil;
    self.picViewsMArray = nil;
}

@end

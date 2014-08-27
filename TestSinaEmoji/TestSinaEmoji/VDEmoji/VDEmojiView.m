//
//  VDEmojiView.m
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "VDEmojiView.h"
#import "VDEmojiPageControl.h"

#define __RGBA(r,g,b,a)           [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//keyboard height
#define VDEmojiKeyboardPortraitHeight 216
#define VDEmojiKeyboardLandscapeHeight 162

//self frame
#define VDEmojiSelfPortraitFrame (CGRectMake(0, VDEmoji_ScreenSize.height - VDEmojiKeyboardPortraitHeight, VDEmoji_ScreenSize.width, VDEmojiKeyboardPortraitHeight))

#define VDEmojiSelfLandscapeFrame (CGRectMake(0, VDEmoji_ScreenSize.width - VDEmojiKeyboardLandscapeHeight, VDEmoji_ScreenSize.height, VDEmojiKeyboardLandscapeHeight))

//rows and column


@interface VDEmojiView ()
{
    int rows, columns;
}

@property (nonatomic,strong) NSMutableArray *picViewsMArray;

@property (nonatomic,strong) NSMutableArray *deleteBtnMArray;

@property (nonatomic,strong) UIScrollView *baseScroll;

@property (nonatomic,strong) VDEmojiPageControl *pageControl;

@end

@implementation VDEmojiView

#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addView];
        
    }
    return self;
}

-(void)addView
{
    _baseScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
    _baseScroll.backgroundColor = __RGBA(0xf1, 0xf1, 0xf1, 1.0f);
    _baseScroll.pagingEnabled = YES;
    _baseScroll.delegate = self;
    _baseScroll.showsVerticalScrollIndicator = NO;
    [self addSubview:_baseScroll];
    
    
    _pageControl = [[VDEmojiPageControl alloc] initWithFrame:CGRectMake(0, _baseScroll.frame.size.height - 20, 320, 5)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    
    _picViewsMArray = [[NSMutableArray alloc] init];
    _deleteBtnMArray = [[NSMutableArray alloc] init];
    
    NSArray *emojies = [[VDEmojiManger sharedVDEmojiManger] getAllEmojies];
    
    for (int i = 0; i <emojies.count; i++) {
        
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
    
    for (int i = 0; i<3; i++) {
        
        UIImageView *delBtn = [[UIImageView alloc] initWithFrame:CGRectZero];
        delBtn.image = [UIImage imageNamed:@"emojiCancel.png"];
        [_baseScroll addSubview:delBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteEmoji:)];
        delBtn.userInteractionEnabled = YES;
        [delBtn addGestureRecognizer:tap];
        
        [self.deleteBtnMArray addObject:delBtn];
    }
    
    [self setStyle:VDEmojiViewStyleNormal];
    [self scrollViewDidScroll:_baseScroll];
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
    
    if (self.delegateEmoji && [self.delegateEmoji respondsToSelector:@selector(vdEmojiView:clickedAtEmoji:isDeleteButton:)])
    {
        [self.delegateEmoji vdEmojiView:self clickedAtEmoji:model isDeleteButton:NO];
    }
}

-(void)deleteEmoji:(UITapGestureRecognizer *)tap
{
    if (self.delegateEmoji && [self.delegateEmoji respondsToSelector:@selector(vdEmojiView:clickedAtEmoji:isDeleteButton:)])
    {
        NSLog(@"delete emoji");
        [self.delegateEmoji vdEmojiView:self clickedAtEmoji:nil isDeleteButton:YES];
    }
}

-(void)setStyle:(VDEmojiViewStyle)style
{
    _style = style;
    _baseScroll.contentOffset = CGPointZero;
    
    switch (style) {
        case VDEmojiViewStyleNormal:
        {
            self.frame = VDEmojiSelfPortraitFrame;
            [self refreshFrameWithRows:4 columns:6];
            break;
        }
        case VDEmojiViewStyleFullScreen:
        {
            self.frame = VDEmojiSelfLandscapeFrame;
            [self refreshFrameWithRows:3 columns:11];
            break;
        }
            
        default:
            break;
    }
}

-(void)refreshFrameWithRows:(int)row columns:(int)column
{
    //总页数
    NSInteger allPageCount = self.picViewsMArray.count / (row * column-1);
    NSInteger residue = self.picViewsMArray.count % (row * column-1);
    if (residue != 0) {
        allPageCount += 1;
    }
    
    NSLog(@"表情页数 : %d",allPageCount);
    _baseScroll.frame = self.bounds;
     _baseScroll.contentSize = CGSizeMake(_baseScroll.frame.size.width*allPageCount, self.frame.size.height);
    _pageControl.frame = CGRectMake(0, _baseScroll.frame.size.height - 20, _baseScroll.frame.size.width, 5);
    self.pageControl.pageCount = allPageCount;
    _pageControl.currentPage = 0;
    rows = row; columns = column;

    int page = 0;
    while (allPageCount > 0)
    {
        
        for (int i = 0; i < row; i++) {
            for (int j = 0; j < column; j++) {
                
                NSInteger index = i*column + j + page*(row*column-1);
                if (index >= self.picViewsMArray.count) {
                    break;
                }
                
                if (i*j == (row-1)*(column-1)) {
                    
                    //删除按钮
                    break;
                }
                
                UIImageView *icon = [self.picViewsMArray objectAtIndex:index];
                
                icon.frame = CGRectMake(20 + j*(30 + 20) + page * _baseScroll.frame.size.width, 15+i*(30+15), 30, 30);
                
            }
        }
        page ++ ;
        allPageCount --;
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    int maxIndx = scrollView.contentSize.width /scrollView.frame.size.width;
    
    UIImageView *icon = [self.deleteBtnMArray objectAtIndex:1];
    icon.frame = CGRectMake(20 + (columns-1)*(30 + 20) + index * _baseScroll.frame.size.width, 15+(rows-1)*(30+15), 30, 30);
    
    if (index - 1 >= 0) {
        UIImageView *icon = [self.deleteBtnMArray objectAtIndex:0];
        icon.frame = CGRectMake(20 + (columns-1)*(30 + 20) + (index-1) * _baseScroll.frame.size.width, 15+(rows-1)*(30+15), 30, 30);
    }
    if (index + 1 <= maxIndx) {
        UIImageView *icon = [self.deleteBtnMArray objectAtIndex:2];
        icon.frame = CGRectMake(20 + (columns-1)*(30 + 20) + (index+1) * _baseScroll.frame.size.width, 15+(rows-1)*(30+15), 30, 30);
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

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
    BOOL      showing;
}

@property (nonatomic,strong) NSMutableArray *picViewsMArray;

@property (nonatomic,strong) NSMutableArray *btnViewsMArray;

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
    _baseScroll.showsHorizontalScrollIndicator = NO;
    [self addSubview:_baseScroll];
    
    
    _pageControl = [[VDEmojiPageControl alloc] initWithFrame:CGRectMake(0, _baseScroll.frame.size.height - 20, 320, 5)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    
    _picViewsMArray = [[NSMutableArray alloc] init];
    _btnViewsMArray = [[NSMutableArray alloc] init];
    _deleteBtnMArray = [[NSMutableArray alloc] init];
    
    NSArray *emojies = [[VDEmojiManger sharedVDEmojiManger] getAllEmojies];
    
    for (int i = 0; i <emojies.count; i++) {
        
        VDEmojiModel *model = [emojies objectAtIndex:i];
        
        UIImageView *icon = [[UIImageView alloc] init];
        icon.image = [UIImage imageNamed:model.png];
        icon.tag = i;
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [_baseScroll addSubview:icon];
        
        [self.picViewsMArray addObject:icon];
        
        
        //add
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectZero;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScroll addSubview:btn];
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        [self.btnViewsMArray addObject:btn];
        

    }
    
    for (int i = 0; i<3; i++) {
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectZero];
        tapView.backgroundColor = [UIColor clearColor];
        tapView.clipsToBounds = YES;
        [_baseScroll addSubview:tapView];
        
        UIImageView *delBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        delBtn.tag = 1001;
        delBtn.image = [UIImage imageNamed:@"emojiCancel.png"];
        delBtn.backgroundColor = [UIColor clearColor];
        [tapView addSubview:delBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteEmoji:)];
        [tapView addGestureRecognizer:tap];
        
        [self.deleteBtnMArray addObject:tapView];

        
//        UIImageView *delBtn = [[UIImageView alloc] initWithFrame:CGRectZero];
//        delBtn.image = [UIImage imageNamed:@"emojiCancel.png"];
//        delBtn.backgroundColor = [UIColor redColor];
//        [_baseScroll addSubview:delBtn];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteEmoji:)];
//        delBtn.userInteractionEnabled = YES;
//        [delBtn addGestureRecognizer:tap];
//        
//        [self.deleteBtnMArray addObject:delBtn];
    }
    
    [self setStyle:VDEmojiViewStyleNormal];
    //[self scrollViewDidScroll:_baseScroll];
}

-(void)setShowEmojiView:(BOOL)showEmojiView
{
    if (showEmojiView) {
        _showEmojiView = YES;
        if (self.style == VDEmojiViewStyleNormal) {
            self.frame = VDEmojiSelfPortraitFrame;
        }else
        {
            self.frame = VDEmojiSelfLandscapeFrame;
        }
    }else {
        _showEmojiView = NO;
        self.center = CGPointMake(self.center.x, VDEmoji_ScreenSize.height + self.frame.size.height/2.0f);
    }

}


/////////////////////////////////////////////////////////////

#pragma mark - tools

-(void)click:(UIButton *)btn
{
    UIButton *icon = btn; //(UIImageView *)tap.view;
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
        
        [self.delegateEmoji vdEmojiView:self clickedAtEmoji:nil isDeleteButton:YES];
    }
}

-(void)setStyle:(VDEmojiViewStyle)style
{
    _style = style;
    _baseScroll.contentOffset = CGPointZero;
    [self.deleteBtnMArray makeObjectsPerformSelector:@selector(setFrame:) withObject:[NSValue valueWithCGRect:CGRectZero]];
    
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
            
            if (VDEmoji_ScreenSize.height == 480) {
            //3.5寸屏特殊处理
                [self refreshFrameWithRows:3 columns:9];
            }else {
                [self refreshFrameWithRows:3 columns:11];
            }
            
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
    [self scrollViewDidScroll:_baseScroll];

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
                float leftMargin = 20;
                if (VDEmoji_ScreenSize.height == 480) {
                    leftMargin = 25;
                }
                icon.frame = CGRectMake(leftMargin + j*(30 + 20) + page * _baseScroll.frame.size.width, 15+i*(30+15), 30, 30);
                
                UIButton *btn = [self.btnViewsMArray objectAtIndex:index];
                btn.frame = CGRectMake(0, 0, 44, 44);
                btn.center = icon.center;
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
    
    float leftMargin = 20;
    if (VDEmoji_ScreenSize.height == 480) {
        leftMargin = 25;
    }
    
    UIImageView *icon = [self.deleteBtnMArray objectAtIndex:1];
    icon.frame = CGRectMake(leftMargin + (columns-1)*(30 + 20) + index * _baseScroll.frame.size.width, 15+(rows-1)*(30+15), 44, 44);
    
    if (index - 1 >= 0) {
        UIImageView *icon = [self.deleteBtnMArray objectAtIndex:0];
        icon.frame = CGRectMake(leftMargin + (columns-1)*(30 + 20) + (index-1) * _baseScroll.frame.size.width, 15+(rows-1)*(30+15), 44, 44);
    }
    if (index + 1 <= maxIndx) {
        UIImageView *icon = [self.deleteBtnMArray objectAtIndex:2];
        icon.frame = CGRectMake(leftMargin + (columns-1)*(30 + 20) + (index+1) * _baseScroll.frame.size.width, 15+(rows-1)*(30+15), 44, 44);
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

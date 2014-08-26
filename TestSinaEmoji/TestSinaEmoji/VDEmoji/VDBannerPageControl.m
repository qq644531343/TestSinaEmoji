//
//  VDBannerPageControl.m
//  KX3
//
//  Created by Nan Cui on 12-11-28.
//  Copyright (c) 2012年 kaixin001. All rights reserved.
//

#import "VDBannerPageControl.h"

@implementation VDBannerPageControl

@synthesize pageCount, currentPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pointViewArray = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [pointViewArray release];
    [super dealloc];
}

- (void)setPageCount:(NSUInteger)_pageCount
{
    if (pageCount != _pageCount)
    {
        for (id tempView in pointViewArray)
        {
            [tempView removeFromSuperview];
        }
        [pointViewArray removeAllObjects];
        
        int x = BANNER_PAGE_CONTROL_W - POINT_W;
        for (int i = 0; i < _pageCount; i++)
        {
            UIImageView *point = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(x, 0, POINT_W, POINT_H)];
            point.layer.cornerRadius = point.frame.size.width / 2;
            point.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
            [self addSubview:point];
            [pointViewArray insertObject:point atIndex:0];
            [point release];
            
            x -= (POINT_W + POINT_DIS);
        }
    }
    
    pageCount = _pageCount;
}

- (void)setCurrentPage:(NSUInteger)_currentPage
{
    currentPage = _currentPage;
    if (currentPage >= pageCount)
    {
        currentPage = pageCount - 1;
    }
    
    for (id item in pointViewArray)
    {
//        [(UIImageView *)item setImage:[UIImage imageNamed:@"photo_stream_icon_gray@2x.png"]];
        UIImageView *point = (UIImageView *)item;
        point.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
    }
    
    if (currentPage < [pointViewArray count])
    {
        UIImageView *point = [pointViewArray objectAtIndex:currentPage];
//        point.image = [UIImage imageNamed:@"photo_stream_icon_blue@2x.png"];
        point.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
    }
}

@end

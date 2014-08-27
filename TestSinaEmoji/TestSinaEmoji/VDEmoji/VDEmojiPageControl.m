

#import "VDEmojiPageControl.h"

@implementation VDEmojiPageControl

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


- (void)dealloc
{
    pointViewArray = nil;
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
        x = self.frame.size.width/2.0f + 23 - POINT_W;
        for (int i = 0; i < _pageCount; i++)
        {
            UIImageView *point = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(x, 0, POINT_W, POINT_H)];
            point.layer.cornerRadius = point.frame.size.width / 2;
            point.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
            [self addSubview:point];
            [pointViewArray insertObject:point atIndex:0];
            
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
        point.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    }
    
    if (currentPage < [pointViewArray count])
    {
        UIImageView *point = [pointViewArray objectAtIndex:currentPage];
//        point.image = [UIImage imageNamed:@"photo_stream_icon_blue@2x.png"];
        //point.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
        point.backgroundColor = [UIColor whiteColor];
    }
}

@end

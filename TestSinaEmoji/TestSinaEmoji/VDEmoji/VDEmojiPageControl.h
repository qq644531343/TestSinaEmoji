

/**
 *
 *  自定义pageControl
 *
 */

#import <UIKit/UIKit.h>

#define POINT_W     5
#define POINT_H     5
#define POINT_DIS   6

#define BANNER_PAGE_CONTROL_W   183
#define BANNER_PAGE_CONTROL_H   POINT_H

@interface VDEmojiPageControl : UIView
{
@private
    NSMutableArray *pointViewArray;
}

@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, assign) NSUInteger currentPage;

@end

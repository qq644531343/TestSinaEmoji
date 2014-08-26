//
//  KCBannerPageControl.h
//  KX3
//
//  Created by Nan Cui on 12-11-28.
//  Copyright (c) 2012年 kaixin001. All rights reserved.
//

/**
 *
 *  banner的自定义pageControl
 *
 */

#import <UIKit/UIKit.h>

#define POINT_W     5
#define POINT_H     5
#define POINT_DIS   6

#define BANNER_PAGE_CONTROL_W   200
#define BANNER_PAGE_CONTROL_H   POINT_H

@interface VDBannerPageControl : UIView
{
@private
    NSMutableArray *pointViewArray;
}

@property (nonatomic, assign) NSUInteger pageCount;
@property (nonatomic, assign) NSUInteger currentPage;

@end

//
//  VDEmojiView.h
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

/**
 *  表情主UI
 *  可根据需要进行继承或重写
 **/

#import <UIKit/UIKit.h>
#import "VDEmojiHeaders.h"

typedef enum VDEmojiViewStyle{
    VDEmojiViewStyleNormal,
    VDEmojiViewStyleFullScreen
}VDEmojiViewStyle;

@protocol VDEmojiViewDelegate;

@interface VDEmojiView : UIView<UIScrollViewDelegate>

@property (nonatomic,weak) id<VDEmojiViewDelegate> delegateEmoji;

@property (nonatomic,readwrite) VDEmojiViewStyle style;

@property (nonatomic,readwrite) BOOL showEmojiView;

//-(void)showEmojiView:(BOOL)show;

@end

/////////////////////////////////////////////////////////////

#pragma mark - VDEmojiViewDelegate

@protocol VDEmojiViewDelegate <NSObject>

@required

-(void)vdEmojiView:(VDEmojiView *)view clickedAtEmoji:(VDEmojiModel *)emodel isDeleteButton:(BOOL)delBtn;

@end

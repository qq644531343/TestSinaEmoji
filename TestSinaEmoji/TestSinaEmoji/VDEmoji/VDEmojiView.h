//
//  VDEmojiView.h
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDEmojiHeaders.h"

typedef enum VDEmojiViewStyle{
    VDEmojiViewStyleNormal,
    VDEmojiViewStyleFullScreen
}VDEmojiViewStyle;

@protocol VDEmojiViewDelegate;

@interface VDEmojiView : UIWindow

@property (nonatomic,weak) id<VDEmojiViewDelegate> delegateEmoji;

@property (nonatomic,readwrite) VDEmojiViewStyle style;

@end

/////////////////////////////////////////////////////////////

#pragma mark - VDEmojiViewDelegate

@protocol VDEmojiViewDelegate <NSObject>

@required

-(void)vdEmojiView:(VDEmojiView *)view clickedAtEmoji:(VDEmojiModel *)emodel;

@end

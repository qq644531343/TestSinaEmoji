
#ifndef VDAttributedLabel_VDAttributedLabelDefines_h
#define VDAttributedLabel_VDAttributedLabelDefines_h

typedef enum
{
    VDImageAlignmentTop,
    VDImageAlignmentCenter,
    VDImageAlignmentBottom
} VDImageAlignment;

@class VDAttributedLabel;

@protocol VDAttributedLabelDelegate <NSObject>
- (void)VDAttributedLabel:(VDAttributedLabel *)label
             clickedOnLink:(id)linkData;

@end

typedef NSArray *(^VDCustomDetectLinkBlock)(NSString *text);

//如果文本长度小于这个值,直接在UI线程做Link检测,否则都dispatch到共享线程
#define VDMinAsyncDetectLinkLength 50

#define VDIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)

#endif

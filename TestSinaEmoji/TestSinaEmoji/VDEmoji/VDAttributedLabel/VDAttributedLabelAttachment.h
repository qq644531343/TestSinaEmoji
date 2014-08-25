//
//  VDAttributedLabelImage.h
//  VDAttributedLabel
//

#import <Foundation/Foundation.h>
#import "VDAttributedLabelDefines.h"

void deallocCallback(void* ref);
CGFloat ascentCallback(void *ref);
CGFloat descentCallback(void *ref);
CGFloat widthCallback(void* ref);

@interface VDAttributedLabelAttachment : NSObject
@property (nonatomic,strong)    id                  content;
@property (nonatomic,assign)    UIEdgeInsets        margin;
@property (nonatomic,assign)    VDImageAlignment   alignment;
@property (nonatomic,assign)    CGFloat             fontAscent;
@property (nonatomic,assign)    CGFloat             fontDescent;
@property (nonatomic,assign)    CGSize              maxSize;


+ (VDAttributedLabelAttachment *)attachmentWith: (id)content
                                          margin: (UIEdgeInsets)margin
                                       alignment: (VDImageAlignment)alignment
                                         maxSize: (CGSize)maxSize;

- (CGSize)boxSize;

@end

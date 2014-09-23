
#import <Foundation/Foundation.h>
#import "VDAttributedLabelDefines.h"


@interface VDAttributedLabelURL : NSObject
@property (nonatomic,strong)    id      linkData;
@property (nonatomic,assign)    NSRange range;
@property (nonatomic,strong)    UIColor *color;

+ (VDAttributedLabelURL *)urlWithLinkData: (id)linkData
                                     range: (NSRange)range
                                     color: (UIColor *)color;


+ (NSArray *)detectLinks: (NSString *)plainText;

+ (void)setCustomDetectMethod:(VDCustomDetectLinkBlock)block;
@end



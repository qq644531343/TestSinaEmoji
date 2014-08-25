//
//  NSMutableAttributedString+VD.h
//  VDAttributedLabel
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface NSMutableAttributedString (VD)

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

- (void)setFont:(UIFont*)font;
- (void)setFont:(UIFont*)font range:(NSRange)range;

- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;

@end

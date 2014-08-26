//
//  VDEmojiToolLabel.m
//  TestSinaEmoji
//
//  Created by libo on 8/25/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "VDEmojiToolLabel.h"

@implementation VDEmojiToolLabel

- (id)initWithFrame:(CGRect)frame textField:(UITextField *)parentfield
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.textAlignment = NSTextAlignmentRight;
        
        self.parentField = parentfield;
        
    }
    return self;
}

#pragma mark - 
-(void)setParentField:(UITextField *)parentField
{
    if (self.parentField) {
         [_parentField removeObserver:self forKeyPath:@"text" context:NULL];
    }
    _parentField = parentField;
    [self setSelfContext];
    [_parentField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        self.text = _parentField.text;
        self.text = [self shortTextWithText:self.text width:self.frame.size.width];
    }
}

-(void)setSelfContext
{
    self.frame = self.parentField.frame;
    self.center = CGPointMake(self.center.x, 40);
    self.font = self.parentField.font;
    self.textColor = self.parentField.textColor;
}


#pragma mark - tool

//反序字符串，计算最大容纳的字符个数
-(NSString *)shortTextWithText:(NSString *)text width:(float)width
{
    float allWidth = 0;
    int i = text.length -1;
    for (; i>=0; i--) {
        if (allWidth >= width) {
            break;
        }
        NSString *subStr = [text substringWithRange:NSMakeRange(i, 1)];
        CGSize size = [subStr sizeWithFont:self.font constrainedToSize:CGSizeMake(320, self.font.pointSize)];
        allWidth += size.width;
    }
    
    if (i>=0 && i+2<=text.length) {
        return [text substringFromIndex:i+2];
    }
    return text; 
}

-(void)dealloc
{
    self.parentField = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
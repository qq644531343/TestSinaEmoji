//
//  VDEmojiToolLabel.m
//  TestSinaEmoji
//
//  Created by libo on 8/25/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "VDEmojiToolLabel.h"
#import "VDEmojiManger.h"

@implementation VDEmojiToolLabel

-(id)init
{
    self = [super init];
    if (self) {
        self.rightMargin = 4.0f;
        [self addTapGes];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame textField:(UITextField *)parentfield
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rightMargin = 4.0f;
        self.parentField = parentfield;
        [self addTapGes];
        
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
        _label.text = _parentField.text;
        _label.text = [self shortTextWithText:_label.text width:_label.frame.size.width];
        //NSLog(@"count:%d",[[VDEmojiManger sharedVDEmojiManger] countFromEmojiString:_parentField.text]);
    }
}

-(void)setSelfContext
{
    self.frame = self.parentField.frame;
    _label.frame = CGRectMake(self.leftMargin, 0, self.frame.size.width - (self.leftMargin + self.rightMargin), self.frame.size.height);
    _label.font = self.parentField.font;
    _label.textColor = self.parentField.textColor;
    self.layer.cornerRadius = self.parentField.layer.cornerRadius;
    self.clipsToBounds = YES;
}


#pragma mark - tool

//反序字符串，计算最大容纳的字符个数
-(NSString *)shortTextWithText:(NSString *)text width:(float)width
{
    float allWidth = 0;
    int i = (int)text.length - 1;
    for (; i>=0; i--) {
        if (allWidth >= width) {
            break;
        }
        NSString *subStr = [text substringWithRange:NSMakeRange(i, 1)];
        CGSize size = [subStr sizeWithFont:_label.font constrainedToSize:CGSizeMake(320, _label.font.pointSize)];
        allWidth += size.width;
    }
    
    if (i>=0 && i+2<=text.length) {
        return [text substringFromIndex:i+2];
    }
    return text; 
}

//切换textfield和label
//传YES隐藏label  传NO隐藏field
-(void)exchange:(BOOL)hidenself
{
    self.hidden = hidenself;
    self.parentField.hidden = ! hidenself;
}

-(void)addTapGes
{
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.backgroundColor = [UIColor clearColor];
    [self addSubview:_label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

-(void)tap:(UITapGestureRecognizer *)tap
{
    [self.parentField becomeFirstResponder];
}

-(void)dealloc
{
    self.parentField = nil;
}

@end

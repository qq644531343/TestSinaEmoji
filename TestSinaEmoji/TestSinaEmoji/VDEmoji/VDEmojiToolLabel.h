//
//  VDEmojiToolLabel.h
//  TestSinaEmoji
//
//  Created by libo on 8/25/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VDEmojiToolLabel : UILabel

-(id)initWithFrame:(CGRect)frame textField:(UITextField *)parentfield;

@property (nonatomic,strong) UITextField *parentField;

//切换textfield和label
//传YES隐藏label  传NO隐藏field
-(void)exchange:(BOOL)hidenself;
 
@end

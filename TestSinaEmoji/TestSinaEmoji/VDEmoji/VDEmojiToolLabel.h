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
 
@end

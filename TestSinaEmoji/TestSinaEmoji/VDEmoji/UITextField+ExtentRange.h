//
//  UITextField+ExtentRange.h
//  TestSinaEmoji
//
//  Created by libo on 8/6/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;

@end

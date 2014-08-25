//
//  VDTableViewCell.h
//  TestSinaEmoji
//
//  Created by libo on 8/6/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VDEmojiHeaders.h"

@interface VDTableViewCell : UITableViewCell

@property (nonatomic,readonly) VDAttributedLabel *label;

@property (nonatomic,retain) NSString *text;

+(double)heightForText:(NSString *)text;

@end

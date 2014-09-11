//
//  VDTableViewCell.m
//  TestSinaEmoji
//
//  Created by libo on 8/6/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "VDTableViewCell.h"

@implementation VDTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _label = [[VDAttributedLabel alloc] initWithFrame:CGRectZero];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor redColor];
        _label.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:_label];

    }
    return self;
}

-(void)setText:(NSString *)text
{
    [[VDEmojiManger sharedVDEmojiManger] generateLabelByString:text imageSize:CGSizeMake(15, 15) enableGif:NO label:_label];
    CGSize size2 = [_label sizeThatFits:CGSizeMake(320, 1000)];
    _label.frame = CGRectMake(0, 0, 320, size2.height);

}

+(double)heightForText:(NSString *)text
{
    static VDAttributedLabel *tmpLabel = nil;
    
    if (text.length > 0) {
        if (!tmpLabel) {
            tmpLabel = [[VDAttributedLabel alloc] initWithFrame:CGRectZero];
            tmpLabel.font = [UIFont systemFontOfSize:15];
            tmpLabel.textColor = [UIColor redColor];
        }
        [tmpLabel setText:@""];
        [[VDEmojiManger sharedVDEmojiManger] generateLabelByString:text imageSize:CGSizeMake(15, 15) enableGif:NO label:tmpLabel];
        CGSize size2 = [tmpLabel sizeThatFits:CGSizeMake(320, 1000)];
        return size2.height;
    }
    return 0.0f;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  VDEmojiManger.h
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VDEmojiModel.h"
#import "VDAttributedLabel/VDAttributedLabel.h"

#define  _regex_emoji  @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]{1,7}+\\]"

@interface VDEmojiManger : NSObject

#pragma mark - public 

/////////////////////////////////////////////////////////////////

+(VDEmojiManger *)sharedVDEmojiManger;

//如果要支持gif，请按命名规范添加相应gif图片
-(BOOL)generateLabelByString:(NSString *)text imageSize:(CGSize)imgsize enableGif:(BOOL)gif label:(VDAttributedLabel *)label;

//删除最后一个表情
//返回删除后的字符串
//beDelete为被删除的字符串
-(NSString *)deleteEmojiFromString:(NSString *)text beDelete:(NSString **)beDelete;

//计算字符个数(表情算一个字符)
-(int )countFromEmojiString:(NSString *)text;

-(NSArray *)getAllEmojies;

-(VDEmojiModel *)getEmojiByIndex:(NSInteger)index;

-(VDEmojiModel *)getEmojiByChs:(NSString *)chs;



#pragma mark - private 

/////////////////////////////////////////////////////////////////

-(BOOL)loadAndParseEmojiPlist;

-(NSArray *)getEmojiChsFromString:(NSString *)string;

-(NSArray *)getClearStringFromString:(NSString *)string;

//no used
-(VDEmojiModel *)getEmojiByPNG:(NSString *)png;

@end

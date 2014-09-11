//
//  VDEmojiManger.m
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "VDEmojiManger.h"
#import "RegexKitLite.h"
#import "UIImage+animatedGIF.h"

@interface VDEmojiManger ()

@property (nonatomic,strong) NSMutableArray *emojiModel_MArray;

@end

@implementation VDEmojiManger

#pragma mark - public

/////////////////////////////////////////////////////////////////

+(VDEmojiManger *)sharedVDEmojiManger
{
    static VDEmojiManger *instance = nil;
    if (!instance) {
        
        instance = [[VDEmojiManger alloc] init];
        instance.emojiModel_MArray = [[NSMutableArray alloc] init];
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [instance loadAndParseEmojiPlist];
        });
        
    }
    
    return instance;
}

-(BOOL)generateLabelByString:(NSString *)text imageSize:(CGSize)imgsize enableGif:(BOOL)gif label:(VDAttributedLabel *)label
{
    
    if (text.length != 0) {
        
        NSArray *array_emoji = [self getEmojiChsFromString:text];
        NSArray *array_string = [self getClearStringFromString:text];
        
        [label setText:@""];
        NSUInteger count = [array_string count];
        for (NSUInteger i = 0; i < count; i++)
        {
            [label appendText:[array_string objectAtIndex:i]];
            
            if (i<array_emoji.count)
            {
                NSString *emojiChs = [array_emoji objectAtIndex:i];
                [self _tempImgAppender:label emojiChs:emojiChs imgsize:imgsize enableGif:gif];
            }
        }
        
        //last
        if ( array_emoji.count > array_string.count) {
            
            NSInteger tcount = array_emoji.count - array_string.count;
            
            for (int j = 0; j < tcount; j++) {
                
                NSString *emojiChs = [array_emoji objectAtIndex:(array_string.count - 1)+j+1];
                [self _tempImgAppender:label emojiChs:emojiChs imgsize:imgsize enableGif:gif];
            }
        }

        
        return YES;

    }
    
    return NO;
}

//删除
-(NSString *)deleteEmojiFromString:(NSString *)text
{
    if (text.length > 0)
    {
        if (text.length >= 3 && [[text substringFromIndex:text.length-1] isEqualToString:@"]"])
        {
            NSArray *array_emoji = [self getEmojiChsFromString:text];
            
            if ([array_emoji count] > 0)
            {
                NSString *endString = [array_emoji objectAtIndex:[array_emoji count] - 1];
                NSString *dstString = [text substringFromIndex:text.length - endString.length];
                
                if ([endString isEqualToString:dstString] && [self getEmojiByChs:endString]) {
                    return [text substringToIndex:text.length - endString.length];
                }else {
                    return [text substringToIndex:text.length-1];
                }
                
            }else {
                return [text substringToIndex:text.length-1];
            }
        }else {
            return [text substringToIndex:text.length-1];
        }
    }
    return text;
}

//计算字符个数(表情算一个字符)
-(int )countFromEmojiString:(NSString *)text
{
    int  count = 0;
    if (text.length != 0)
    {
        NSArray *array_emoji = [self getEmojiChsFromString:text];
        NSArray *array_string = [self getClearStringFromString:text];
        
        count += array_emoji.count;
        
        for (NSString *str in array_string) {
            count += [VDEmojiManger VDChineseCountWords:str];
        }
    }
    return count;
}

-(NSArray *)getAllEmojies
{
    return self.emojiModel_MArray;
}

-(VDEmojiModel *)getEmojiByIndex:(NSInteger)index
{
    if (index >= 0 && index < [self.emojiModel_MArray count]) {
        return [self.emojiModel_MArray objectAtIndex:index];
    }
    
    return nil;
}

-(VDEmojiModel *)getEmojiByChs:(NSString *)chs
{
    if (chs.length >0) {
        
        for (VDEmojiModel *model in self.emojiModel_MArray) {
            if ([chs isEqualToString:model.chs]) {
                return model;
            }
        }
    }
    
    return nil;
}

-(VDEmojiModel *)getEmojiByPNG:(NSString *)png
{
    if (png.length > 0) {
        for (VDEmojiModel *model in self.emojiModel_MArray) {
            if ([png isEqualToString:model.png]) {
                return model;
            }
        }
    }
    
    return nil;
}

#pragma mark - private

/////////////////////////////////////////////////////////////////

-(BOOL)loadAndParseEmojiPlist
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoji_video" ofType:@"plist"];
    if (!path)
    {
        NSLog(@"Emoji Error: can't find plist");
        return NO;
    }
    
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *emojArray = [rootDic objectForKey:@"emoticon_group_emoticons"];
    [self.emojiModel_MArray removeAllObjects];
    
    for (int i = 0; i < [emojArray count]; i++)
    {
        
        NSDictionary *emoDic = [emojArray objectAtIndex:i];
     
        VDEmojiModel *model = [[VDEmojiModel alloc] init];
        model.chs = [emoDic objectForKey:@"chs"];
        model.png = [emoDic objectForKey:@"png"];
        model.gif = [emoDic objectForKey:@"gif"];
        model.index = i;
        
        [self.emojiModel_MArray addObject:model];
        
    }
    
    return YES;
}

-(NSArray *)getEmojiChsFromString:(NSString *)string
{
    NSArray *array_emoji = [string componentsMatchedByRegex:_regex_emoji];
    
    return [NSArray arrayWithArray:array_emoji];
}

-(NSArray *)getClearStringFromString:(NSString *)string
{
    NSArray *array_string = [string componentsSeparatedByRegex:_regex_emoji];
    
    return [NSArray arrayWithArray:array_string];
}

-(VDAttributedLabel *)_tempImgAppender:(VDAttributedLabel *)label emojiChs:(NSString *)chs imgsize:(CGSize)size enableGif:(BOOL)gif
{
    VDEmojiModel *model = [self getEmojiByChs:chs];

    if (model) {
        if (!gif || model.gif.length == 0)
        {
            [label appendImage:[UIImage imageNamed:model.png]
                       maxSize:size
                        margin:UIEdgeInsetsZero
                     alignment:VDImageAlignmentCenter];
        }else{
            
            model.gif = @"88_thumb.gif";
            NSArray *names = [model.gif componentsSeparatedByString:@"."];
            if ([names count] == 2) {
                NSString *path = [[NSBundle mainBundle] pathForResource:[names objectAtIndex:0] ofType:@"gif"];
                NSData *imgdata = [[NSData alloc] initWithContentsOfFile:path];
                UIImage *img =  [UIImage animatedImageWithAnimatedGIFData:imgdata];
                
                if (!img) {
                    [label appendText:chs];
                    return label;
                }
                
                UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                imgview.image = img;
                [label appendView:imgview];
            }
        }
    }else{
        [label appendText:chs];
    }

    return nil;
}

#pragma mark - Tool


+ (NSUInteger)VDChineseCountWords:(NSString *)text
{
    int i, n = [text length], l = 0, a = 0, b = 0;
    unichar c;
    
    for(i = 0; i < n; i++){
        c = [text characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    
    return l+(int)ceilf((float)(a+b)/2.0);
}

@end

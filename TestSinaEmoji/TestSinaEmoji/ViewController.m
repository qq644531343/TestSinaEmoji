//
//  ViewController.m
//  TestSinaEmoji
//
//  Created by libo on 8/4/14.
//  Copyright (c) 2014 sina. All rights reserved.
//

#import "ViewController.h"
#import "VDAttributedLabel.h"
#import "RegexKitLite/RegexKitLite.h"
#import "VDTableViewCell.h"
#import "UITextField+ExtentRange.h"

@interface ViewController ()
{
    UITextView *field;
    VDEmojiView *emojiView;
    CGRect      fixedEmojiFrame;
    CGRect      screenframe;
    UITableView *tableview;
    
    NSMutableArray  *dataMArray;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    dataMArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<100; i++) {
        NSString *text  = @"[geli][吃惊]say:[草泥马] [haha] Your magic is Mine.[haha] [haha][geli][擦擦]";
        [dataMArray addObject:text];
    }
    
    [self addEmoji];
    [self addTableView];
    
}

-(void)addTableView
{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 320, screenframe.size.height - 216 - 35 - 20)];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
}

-(void)addEmoji
{
    int keyboardHeight = 216;
    screenframe = [[UIScreen mainScreen] bounds];
    
    NSString *text  = @"[geli][吃惊]say:[草泥马] [haha] Your magic is Mine.[haha] [haha][geli][擦擦]";
    VDAttributedLabel *label2 = [[VDAttributedLabel alloc] initWithFrame:CGRectZero];
    [[VDEmojiManger sharedVDEmojiManger] generateLabelByString:text imageSize:CGSizeMake(15, 15) enableGif:NO label:label2];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = [UIColor redColor];
    CGSize size2 = [label2 sizeThatFits:CGSizeMake(320, 1000)];
    label2.frame = CGRectMake(0, 100, 320, size2.height);
    label2.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:label2];
    
    field = [[UITextView alloc] initWithFrame:CGRectMake(0, screenframe.size.height - keyboardHeight - 35, 260, 35)];
    field.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.5];
    field.font = [UIFont systemFontOfSize:17];
    field.delegate = self;
    [self.view addSubview:field];
    [field becomeFirstResponder];
    
    UIButton *swichBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    swichBtn.frame = CGRectMake(260, field.frame.origin.y, 60, 35);
    [swichBtn setTitle:@"switch" forState:UIControlStateNormal];
    swichBtn.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:swichBtn];

//    UIButton *swichBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    swichBtn.frame = CGRectMake(260, field.frame.origin.y, 60, 35);
//    [swichBtn setTitle:@"switch" forState:UIControlStateNormal];
//    swichBtn.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3];
//    field.rightView = swichBtn;
//    field.rightViewMode = UITextFieldViewModeAlways;
    
    
    emojiView = [[VDEmojiView alloc] initWithFrame:CGRectMake(0, screenframe.size.height - keyboardHeight, screenframe.size.width, keyboardHeight)];
    emojiView.hidden = YES;
    emojiView.delegateEmoji = self;
    emojiView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view.window addSubview:emojiView];
    fixedEmojiFrame = emojiView.frame;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    [swichBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - keyboard

-(void)change {
    
    //NSLog(@"%d",field.isFirstResponder);
    if (field.isFirstResponder) {
        [field resignFirstResponder];
    }else {
        [field becomeFirstResponder];
    }
}

-(void)showKeyboard:(NSNotification *)noti
{
    
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"hiden" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve: [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    //emojiView.frame = CGRectMake(0, screenframe.size.height, screenframe.size.width, fixedEmojiFrame.size.height);
    emojiView.center = CGPointMake(emojiView.center.x, screenframe.size.height + emojiView.frame.size.height/2.0f);

    [UIView commitAnimations];

}

-(void)hidenKeyboard:(NSNotification *)noti
{
    emojiView.frame = CGRectMake(0, screenframe.size.height, screenframe.size.width, fixedEmojiFrame.size.height);
    emojiView.hidden = NO;
    
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve: [[noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
    
    emojiView.frame = fixedEmojiFrame;
    
    [UIView commitAnimations];

    
}

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataMArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [VDTableViewCell heightForText:[dataMArray objectAtIndex:indexPath.row]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[VDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.text = [dataMArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self sendData:field.text];
        field.text = @"";
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [self sendData:textField.text];
        textField.text = @"";
    }
    return YES;
}

#pragma mark -

-(void)sendData:(NSString *)text
{
    if (text) {
        [dataMArray addObject:text];
        [tableview beginUpdates];
        NSIndexPath *newHistoryMessageIndexPath = [NSIndexPath indexPathForRow:dataMArray.count-1 inSection:0];
        // update history table-view
        [tableview insertRowsAtIndexPaths:[NSArray arrayWithObject:newHistoryMessageIndexPath]
                                     withRowAnimation:UITableViewRowAnimationFade];
        [tableview endUpdates];
        [tableview scrollToRowAtIndexPath:newHistoryMessageIndexPath
                                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

#pragma mark - 
-(void)vdEmojiView:(VDEmojiView *)view clickedAtEmoji:(VDEmojiModel *)emodel
{
    field.text = [NSString stringWithFormat:@"%@%@",field.text,emodel.chs];
    int rows = [self numOfRows];
    if (rows == 2) {
        field.frame = CGRectMake(field.frame.origin.x, screenframe.size.height - 216 - 35*rows, 260, 35 * (rows));
        [self.view bringSubviewToFront:field];
    }
    
}

//计算行数
-(int)numOfRows
{
    
    CGSize size = [field.text sizeWithFont:field.font constrainedToSize:CGSizeMake(field.frame.size.width - 5, 1000)];
    int rows =  size.height / field.font.lineHeight;
    if (((int)size.height % (int)field.font.lineHeight) > 0) {
        rows ++;
    }
    return rows;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  SKWKWebView.m
//  DangJian
//
//  Created by Sakya on 2017/8/30.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKWKWebView.h"

@implementation SKWKWebView {
    NSString *_title;
}

- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        
        _title = title;
        [self menuInit];
    }
    return self;
}
-(void)menuInit {
    
    [self becomeFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *item0 = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyContent:)];
    UIMenuItem *menuItemNote = [[UIMenuItem alloc] initWithTitle:@"加入笔记" action:@selector(addNote:)];
    NSArray *mArray = [NSArray arrayWithObjects:item0,menuItemNote, nil];
    [menuController setMenuItems:mArray];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    NSLog(@"%@", NSStringFromSelector(action));
    //只显示系统自带
    //return [super canPerformAction:action withSender:sender];
    
    //只显示自定义
    if (action == @selector(copy:) ||
        action == @selector(addNote:) ||
        action == @selector(copyContent:)) {
        return YES;
    }
        return NO;
    
    //系统和自定义都显示
//    if (action == @selector(copy:) ||
//        action == @selector(addNote:) ||
//        action == @selector(copyContent:)) {
//        return YES;
//    }
//    return [super canPerformAction:action withSender:sender];//
}
-(void)addNote:(id)sender
{
    [self evaluateJavaScript:@"window.getSelection().toString()" completionHandler:^(id _Nullable content, NSError * _Nullable error) {
        NSLog(@"%s %@,", __func__,content);
        NSString *selectContent = (NSString *)content;
        DDLogDebug(@"%@",selectContent);
    }];
    /**
    [SKHUDManager showLoading];
    __weak typeof(self) weakSelf = self;
    [InterfaceManager addNotesTitle:_title content:selectContent success:^(id result) {
        if ([ThePartyHelper showPrompt:YES returnCode:result]) {
            [SKHUDManager showBriefAlert:@"笔记添加成功"];
        }
    } failed:^(id error) {
    }];
    */
    
}
- (void)copyContent:(id)sender {
    
}
//  说明控制器可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return YES;
}

- (void)dealloc {
    [self removeFromSuperview];

}
@end

//
//  SKUIWebView.m
//  DangJian
//
//  Created by Sakya on 2017/8/30.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKUIWebView.h"

@implementation SKUIWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        [self menuInit];
    }
    return self;
}
-(void)menuInit
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *menuItemNote = [[UIMenuItem alloc] initWithTitle:@"加入笔记" action:@selector(addNote:)];
    NSArray *mArray = [NSArray arrayWithObjects:menuItemNote, nil];
    
    [menuController setMenuItems:mArray];
    
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(addNote:))
    {
        return YES;
    }
    return [super canPerformAction:action withSender:sender];//
}
-(void)addNote:(id)sender
{
    NSString* selectionString = [self stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    DDLogDebug(@"%@",selectionString);
}
@end

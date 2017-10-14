//
//  SKInputTextView.h
//  DangJian
//
//  Created by Sakya on 2017/9/25.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MaxTextViewHeight 80 //限制文字输入的高度
typedef NS_OPTIONS(NSInteger, SKInputTextViewType) {
    
    SKInputTextViewGeneralType = 0,
    SKInputTextViewPictureType = 1,
    //会自动消失的
    SKInputTextViewPictureAutoDisType = 2,
};

@interface SKInputTextView : UIView<UITextViewDelegate,UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame
            inputTextViewType:(SKInputTextViewType)type;

//------ 发送文本 和图片 图片可为空-----//
@property (nonatomic,copy) void (^EwenTextViewBlock)(NSString *text, NSArray <UIImage *>*imageArray);
//------  设置占位符 ------//
- (void)setPlaceholderText:(NSString *)text;

@property (nonatomic, strong) UITextView *textView;

@end

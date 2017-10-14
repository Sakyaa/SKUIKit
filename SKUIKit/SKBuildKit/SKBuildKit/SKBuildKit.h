//
//  SKBuildKit.h
//  SKBuildKitDemo
//
//  Created by Sakya on 2017/6/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SKBuildKit : NSObject
/**
 *text
 */
+ (UILabel *)labelBackgroundColor:(UIColor *)backgroundColor
                       textColor:(UIColor *)textColor
                    textAligment:(NSTextAlignment)textAligment
                   numberOfLines:(NSInteger)numberOfLines
                            text:(NSString *)text
                            font:(UIFont *)font;

/*
 *attributedString
 */
+ (UILabel *)labelAttributedText:(NSMutableAttributedString *)text
                backgroundColor:(UIColor *)backgroundColor
                   textAligment:(NSTextAlignment)textAligment
                  numberOfLines:(NSInteger)numberOfLines;


/**
 返回 eAttributedString
 
 @param string 输入的文字
 @param lineSpace 文本行距
 @param firstLineHeadIndent 首行缩进
 @param textColor 文本颜色
 @param font 文本大小
 @return 返回文本
 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string
                                                lineSpace:
(CGFloat)lineSpace
                                      firstLineHeadIndent:
(CGFloat)firstLineHeadIndent
                                                textColor:
(UIColor *)textColor
                                                 textFont:
(UIFont *)font;

/**
 创建tableView
 
 @param frame 位置大小
 @param agent delegate
 @param superview 父视图
 @return tableView
 */
+ (UITableView *)tableViewWithFrame:(CGRect)frame
                      delegateAgent:(id)agent
                          superview:(UIView *)superview;
/**
 创建 button
 
 */
+ (UIButton *)buttonTitle:(NSString *)title
          backgroundColor:(UIColor *)backgroundColor
               titleColor:(UIColor *)titleColor
                     font:(UIFont *)font
             cornerRadius:(CGFloat)cornerRadius
                superview:(UIView *)superview;

+ (UIButton *)buttonWithImageName:(NSString *)imageName
                        superview:(UIView *)superview
                           target:(id)target
                           action:(SEL)action;
@end

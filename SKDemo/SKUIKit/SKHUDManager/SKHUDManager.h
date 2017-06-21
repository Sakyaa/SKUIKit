//
//  PYFHUDManager.h
//  UnionProgarm
//
//  Created by Sakya on 17/2/23.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 说明：
 *        目前存在的bug，当app还未启动完成，当前的window为nil，这个时候如果调用不指定view的方法会造成提示框不显示的问题
 * 解决方法：
 *              使用制定view的加载提示，如addToView:self.view
 *
 */

@interface SKHUDManager : NSObject

//针对SVProgressHUD 和 MBProgressHUD

#pragma mark -- 全部需要用到的库 svp  mbpr 等
/**
 显示成功的提示

 @param prompt 成功描述
 */
+ (void)showSuccessWithPrompt:(NSString *)prompt;
//针对一些界面无法显示
+ (void)showSuccessWithPrompt:(NSString *)prompt addedTo:(UIView *)view;

/**
 显示失败描述

 @param prompt 描述
 */
+ (void)showErrorWithPrompt:(NSString *)prompt;
+ (void)showErrorWithPrompt:(NSString *)prompt addedTo:(UIView *)view;


/**
 *  只显示圆圈
 */
+ (void)show;
+ (void)showAddedTo:(UIView *) view;

/**
 *  显示“加载中”，待圈圈，若要修改直接修改kLoadingMessage的值即可
 */
+ (void)showLoading;
+ (void)showLoadingAddedTo:(UIView *)view;




/**
 自定义加载中的提示语

 @param prompt 提示语
 */
+ (void)showLoadingPrompt:(NSString *)prompt;
+ (void)showLoadingPrompt:(NSString *)prompt addedTo:(UIView *) view;

/**
 *  一直显示自定义提示语，不带圈圈
 *
 *  @param prompt 提示信息
 */
+ (void)showPermanentPrompt:(NSString *)prompt;
+ (void)showPermanentPrompt:(NSString *)prompt addedTo:(UIView *) view;

/**
 *  显示简短的提示语，默认1秒钟，时间可直接修改kShowTime
 *
 *  @param prompt 提示信息
 */
+ (void)showBriefPrompt:(NSString *) prompt;
+ (void)showBriefPrompt:(NSString *) prompt addedTo:(UIView *) view;

///**
// *  自定义加载视图接口，支持自定义图片
// *
// *  @param imageName  要显示的图片，最好是37 x 37大小的图片
// *  @param title 要显示的提示文字
// */
+(void)showAlertWithCustomImage:(NSString *)imageName title:(NSString *)title;
+(void)showAlertWithCustomImage:(NSString *)imageName title:(NSString *)title addedTo:(UIView *)view;

/**
 *  隐藏alert
 */
+(void)hideAlert;


#pragma mark -  MBProgressHUD
/**
 *  是否显示变淡效果，默认为YES，  PS：只为 showPermanentAlert:(NSString *) alert 和 showLoading 方法添加
 */
+ (void)showGloomy:(BOOL) isShow;
@end


@interface GloomyView : UIView<UIGestureRecognizerDelegate>
@end

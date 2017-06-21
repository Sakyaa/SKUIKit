//
//  SKAlertView.h
//  UnionProgarm
//
//  Created by Sakya on 17/3/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SKAlertViewStyle) {
    
    /**默认提示框 */
    SKAlertViewStyleDefault = 0,
    /**需要输入框的提示*/
    SKAlertViewStyleTextField = 1,
    
};

typedef NS_OPTIONS(NSInteger, SKAlertViewButtonConfiguration) {
    
    /**水平button*/
    SKAlertViewButtonConfigurationHorizontal = 0,
    /**竖直button*/
    SKAlertViewButtonConfigurationVertical = 1,
};

@protocol SKAlertViewDelegate <NSObject>

/**输出填写的文字*/
- (void)alertViewTextFieldChangedDetectedText:(NSString *)text;

/**点击确定按钮*/
- (void)alertViewActionDetected:(UIButton *)sender;

@end

@interface SKAlertView : UIView


#pragma mark - Customization
@property (assign, nonatomic) UIWindowLevel maxSupportedWindowLevel; // default is UIWindowLevelNormal

@property (nonatomic, copy) NSString *content; // 提示信息或者输入信息
@property (nonatomic, copy) NSString *placeholder; // textField placeholder

@property (strong, nonatomic) UIView *containerView;                                // if nil then use default window level

//提示框类型
@property (nonatomic, assign) SKAlertViewStyle alertType; //default is lable

@property (nonatomic, assign) SKAlertViewButtonConfiguration buttonConfiguration; //button类型 default is Horizontal

@property (nonatomic, weak) id<SKAlertViewDelegate>delegate; //delegate


/**frame 可以不传*/
- (instancetype)initWithFrame:(CGRect)frame
                       title:(NSString *)title
                 buttonArray:(NSArray *)buttonArray;


- (void)show;

- (void)dissmiss;

@end

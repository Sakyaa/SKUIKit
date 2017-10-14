//
//  SKTextField.h
//  ThePartyBuild
//
//  Created by Sakya on 17/4/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SKTextFieldStyle) {
    
    //正常的 左侧为 title 提示
    SKTextFieldNormalStyle = 0,
    //左侧为图片信息
    SKTextFieldImageStyle = 1
};

@interface SKTextField : UITextField


- (instancetype)initWithLeftSpace:(CGFloat)leftSpace
                            style:(SKTextFieldStyle)style;
//左侧图片名字 SKTextFieldImageStyle
@property (nonatomic, copy) NSString *imageName;
//左侧文字 SKTextFieldNormalStyle
@property (nonatomic, copy) NSString *leftText;



@end

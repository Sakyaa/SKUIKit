//
//  SKPlaceholderView.h
//  SKDemo
//
//  Created by Sakya on 17/3/28.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SKPlaceholderViewType) {
    
    SKPlaceholderViewOnlyTitleType = 1,
    
    /**包含图片 按钮 标题和副标题*/
    SKPlaceholderViewDefaultType = 2,
    
    /**包含图片文字*/
    SKPlaceholderViewSimpleType ,
};

@protocol SKPlaceholderViewDelegate <NSObject>

/**按钮点击*/
- (void)placeholderViewButtonActionDetected:(UIButton *)sender;

@end

@interface SKPlaceholderView : UIView

/**显示内容*/
@property (nonatomic, copy) NSString *titleText;



/**点击的button*/
@property (nonatomic, strong) UIButton *defaultButton;
/**显示文字信息*/
@property (nonatomic, strong) UILabel *titleLabel;

/**描述文字*/
@property (nonatomic, strong) UILabel *detailLabel;


/**按钮文字*/
@property (nonatomic, copy) NSString *buttonTitle;

/**显示图片名字*/
@property (nonatomic, copy) NSString *imageName;


@property (nonatomic, weak) id<SKPlaceholderViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame placeholderType:(SKPlaceholderViewType)placeholderType;

@end

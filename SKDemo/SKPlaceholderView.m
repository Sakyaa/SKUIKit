//
//  SKPlaceholderView.h
//  pczd_ios
//
//  Created by Sakya on 16/9/25.
//  Copyright © 2016年 优谱德. All rights reserved.
//

#import "SKPlaceholderView.h"

#define ImageViewWidth  80
#define ImageViewHigth 80
//设备屏幕尺寸 scale
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

@interface SKPlaceholderView () {
    
    SKPlaceholderViewType _viewType;
    
    UIImageView *_placeholderImageView;
    
    
}

@end


@implementation SKPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame placeholderType:(SKPlaceholderViewType)placeholderType {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _viewType = placeholderType;

        [self initCustomView];
        
    }
    return self;
}
#pragma mark -- setter
- (void)setTitleText:(NSString *)titleText {
    
    _titleText = titleText;
    _titleLabel.text = titleText;
    
}
- (void)setImageName:(NSString *)imageName {
    
    [_placeholderImageView setImage:[UIImage imageNamed:imageName]];
}

-(void)initCustomView {
    
    CGFloat labelOriginY = 50;
    if (_viewType == SKPlaceholderViewDefaultType) {
        labelOriginY = 60;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x - ImageViewWidth/2, labelOriginY, ImageViewWidth, ImageViewHigth)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imageView];
        labelOriginY = CGRectGetMaxY(imageView.frame) + 15;
        _placeholderImageView = imageView;
        
    }
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, labelOriginY, self.bounds.size.width - 40, 40)];

    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    labelOriginY += 40;
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, labelOriginY, self.bounds.size.width - 60, 40)];

    [detailLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:detailLabel];
    _detailLabel = detailLabel;
    labelOriginY += 50;
    
    if (_viewType == SKPlaceholderViewDefaultType) {
        
        UIButton *defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [defaultButton setFrame:CGRectMake(15, labelOriginY, kScreen_Width - 30, 45)];
        [defaultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [defaultButton setTitle:@"完成" forState:UIControlStateNormal];
        [defaultButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [defaultButton.layer setMasksToBounds:YES];
        [defaultButton addTarget:self action:@selector(clickEventsDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:defaultButton];
        _defaultButton = defaultButton;
    }
}

- (void)clickEventsDelete:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeholderViewButtonActionDetected:)]) {
        [self.delegate placeholderViewButtonActionDetected:sender];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

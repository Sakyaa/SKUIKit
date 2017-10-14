//
//  SKTimeSelectorView.m
//  CCDMonitoring
//
//  Created by Sakya on 2017/8/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "SKTimeSelectorView.h"
#import "XHDatePickerView.h"
#import "NSDate+Extension.h"

//显示视图的大小
CGFloat const WidthTimeSelectorView = 230.0f;
//左右边距的距离
CGFloat const MarginToEdge = 10.0f;
//左右边距的距离
CGFloat const MarginToTopEdge = 180.0f;
//两个控件的间距
CGFloat const SpacingToX = 20.0f;
//空间的高度
CGFloat const HeightSelectButton = 45.0f;

//TAG
//日期选择的button
NSInteger const TAG_DATESELECT_BUTTON = 1000;
//确定取消tag
NSInteger const TAG_BOTTOM_BUTTON = 10000;



@interface SKTimeSelectorView ()

@property (nonatomic, strong) UIView *backView;
//开始时间
@property (nonatomic, copy) NSString *startTimeText;
//结束时间
@property (nonatomic, copy) NSString *endTimeText;

@property (nonatomic, assign) SKTimeSelectorType timeType;

@end

@implementation SKTimeSelectorView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpCustomView];
        [self initCustomView];
    }
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        [self setUpCustomView];
        [self initCustomView];
    }
    return self;
}
- (void)setUpCustomView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.frame = [UIScreen mainScreen].bounds;
    UITapGestureRecognizer *tapGuserture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDetected:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];

    [self addGestureRecognizer:tapGuserture];
    [self addGestureRecognizer:panGesture];

    _timeType = SKTimeSelectorTodayType;
}
- (void)initCustomView {
    //背景
    UIView *backView = [[UIView alloc] init];
    [self addSubview:backView];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(kScreenWidth, 0, SKXFrom6(WidthTimeSelectorView), kScreenHeight);
    _backView = backView;
    
    //求出控件的大小内间距
    CGFloat widthItem = (backView.sk_width - SKXFrom6(MarginToEdge) * 2 - SKXFrom6(SpacingToX))/2;
//    固定
    UILabel *startTitleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:COLOR_HEX6 textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"开始时间" font:FONT_15];
    [backView addSubview:startTitleLabel];
    startTitleLabel.sk_size = CGSizeMake(widthItem, SKXFrom6(HeightSelectButton));
    startTitleLabel.sk_left = SKXFrom6(MarginToEdge);
    startTitleLabel.sk_top = SKXFrom6(MarginToTopEdge);
    
    UILabel *endTitleLabel = [SKBuildKit labelWithBackgroundColor:nil textColor:COLOR_HEX6 textAligment:NSTextAlignmentCenter numberOfLines:1 text:@"结束时间" font:FONT_15];
    [backView addSubview:endTitleLabel];
    endTitleLabel.sk_size = CGSizeMake(widthItem, SKXFrom6(HeightSelectButton));
    endTitleLabel.sk_left = SKXFrom6(MarginToEdge) + widthItem + SKXFrom6(SpacingToX);
    endTitleLabel.sk_top = SKXFrom6(MarginToTopEdge);
    //创建选择时间控件
    
    NSArray *daysArray = @[@"今天",
                           @"3天",
                           @"7天",
                           @"30天"];
    //********* 选择
    for (NSInteger i = 0; i < 3; i ++) {
        for (NSInteger column = 0; column < 2; column ++) {
            
            @autoreleasepool {
                UIButton *button = [SKBuildKit buttonTitle:nil backgroundColor:nil titleColor:COLOR_HEX6 font:FONT_14 cornerRadius:ControlsCornerRadius superview:backView];
                button.layer.borderColor = COLOR_LIGHTGRAY_SEPARATEDLINE.CGColor;
                button.layer.borderWidth = 1;
                button.sk_size = CGSizeMake(widthItem, HeightSelectButton);
                //                tag
                button.tag = TAG_DATESELECT_BUTTON + 2 * i + column;
                [button addTarget:self action:@selector(dateSelectAction:) forControlEvents:UIControlEventTouchUpInside];
                //位置
                button.sk_left = SKXFrom6(MarginToEdge) + (widthItem + SKXFrom6(SpacingToX)) * column;
                
                
                if (i == 0) {
                    button.sk_top = startTitleLabel.sk_bottom + (MarginToEdge + HeightSelectButton) * i;
 
                } else if (i == 1) {
                    button.sk_top = startTitleLabel.sk_bottom + (MarginToEdge + HeightSelectButton) * i+ MarginToEdge;
                    [button setTitle:daysArray[i * 2 + column - 2] forState:UIControlStateNormal];
                    [button setTitleColor:COLOR_HEX6 forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

                } else if (i == 2) {
                    button.sk_top = startTitleLabel.sk_bottom + (MarginToEdge + HeightSelectButton) * i+ MarginToEdge;
                    [button setTitle:daysArray[i * 2 + column - 2] forState:UIControlStateNormal];
                    [button setTitleColor:COLOR_HEX6 forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

                }
//设置默认今天为选中状态
                if (i * 2 + column == 2) {
                    button.backgroundColor = COLOR_BLUE_SYSTEM;
                    button.layer.borderWidth = 0.0f;
                    button.selected = YES;
                }
                
            }
        }
    }
    
    //底部确定取消按钮
    for (NSInteger i =0 ; i < 2; i ++) {

        @autoreleasepool {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [backView addSubview:button];
            button.sk_size = CGSizeMake(backView.sk_width/2, HeightSelectButton);
            //位置
            button.sk_left = backView.sk_width/2 * i;
            button.sk_bottom = backView.sk_bottom;
            button.tag = TAG_BOTTOM_BUTTON + i;
            [button addTarget:self action:@selector(cancelOrDetermineAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [button setTitle:@"取消" forState:UIControlStateNormal];
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:COLOR_BLUE_SYSTEM forState:UIControlStateNormal];
                CALayer *topLine = [CALayer layer];
                topLine.frame = CGRectMake(0, - 2, button.sk_width, 1);
                topLine.backgroundColor = [UIColor whiteColor].CGColor;
                [topLine setLayerShadow:COLOR_BLUE_SYSTEM offset:CGSizeMake(1.5, 1.5) radius:0];
                [button.layer addSublayer:topLine];

                
            } else {
                [button setTitle:@"确定" forState:UIControlStateNormal];
                button.backgroundColor = COLOR_BLUE_SYSTEM;
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }


        }
        
    }
}



#pragma mark -- UITapGestureRecognizer
- (void)tapGestureDetected:(UITapGestureRecognizer *)sender {
    
    [self sk_timeViewClose];
}
- (void)panGestureDetected:(UIPanGestureRecognizer *)sender {
    
    CGPoint translatedPoint = [sender translationInView:self];
    if (translatedPoint.x > 0) {
        _backView.frame = CGRectMake(kScreenWidth - SKXFrom6(WidthTimeSelectorView) + translatedPoint.x, 0, SKXFrom6(WidthTimeSelectorView), kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:(1 - translatedPoint.x/(kScreenWidth/2)) * 0.5];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_backView.sk_origin.x > kScreenWidth/2) {
            [self sk_timeViewClose];
        } else {
            [self sk_timeViewShow];
        }
    }
    
}


#pragma mark -- action
//时间选择
- (void)dateSelectAction:(UIButton *)sender {
    NSInteger butttonTag = sender.tag;
    for (UIButton *button in _backView.subviews) {
        if (button && [button isKindOfClass:[UIButton class]]) {
            if (button.tag == 1002 ||
                button.tag == 1003 ||
                button.tag == 1004 ||
                button.tag == 1005 ) {
                button.selected = NO;
                button.backgroundColor = [UIColor whiteColor];
                button.layer.borderWidth = 1;
            }
        }
    }
    if (butttonTag == 1000 ||
        butttonTag == 1001) {
        
        XHDateType dateType;
        NSString *currentDateString;
        if (butttonTag == 1000) {
            dateType = DateTypeStartDate;
            currentDateString = _startTimeText;
        } else if (butttonTag == 1001) {
            dateType = DateTypeEndDate;
            currentDateString = _endTimeText;
        }
        XHDatePickerView *datepicker = [[XHDatePickerView alloc] initWithCurrentDate:[NSDate date:currentDateString WithFormat:TIME_FORMAT_TYPE] CompleteBlock:^(NSDate *startDate, NSDate *endDate) {
            NSLog(@"\n开始时间： %@，结束时间：%@",startDate,endDate);
            _timeType = SKTimeSelectorStartEndType;
            if (startDate) {
                _startTimeText = [startDate stringWithFormat:TIME_FORMAT_TYPE];
                [(UIButton *)[_backView viewWithTag:1000] setTitle:[startDate stringWithFormat:@"yyyy/MM/dd"] forState:UIControlStateNormal];
            }
            if (endDate) {
                _endTimeText = [endDate stringWithFormat:TIME_FORMAT_TYPE];
                [(UIButton *)[_backView viewWithTag:1001] setTitle:[endDate stringWithFormat:@"yyyy/MM/dd"] forState:UIControlStateNormal];
            }
        }];
        datepicker.themeColor = COLOR_BLUE_SYSTEM;
        datepicker.datePickerStyle = DateStyleShowYearMonthDay;
        datepicker.dateType = dateType;
        [datepicker show];
    } else {
        
        NSString *days;
        if (butttonTag == 1002) {
            _timeType = SKTimeSelectorTodayType;
            days = @"1";
        } else if (butttonTag == 1003) {
            _timeType = SKTimeSelectorThreeType;
             days = @"3";
        } else if (butttonTag == 1004) {
            _timeType = SKTimeSelectorSevenType;
            days = @"7";
            
        } else if (butttonTag == 1005) {
            _timeType = SKTimeSelectorThirtyType;
            days = @"30";
        }
        sender.selected = YES;
        sender.backgroundColor = COLOR_BLUE_SYSTEM;
        sender.layer.borderWidth = 0;
  //清空开始和结束时间
        [(UIButton *)[_backView viewWithTag:1000] setTitle:nil forState:UIControlStateNormal];
        [(UIButton *)[_backView viewWithTag:1001] setTitle:nil forState:UIControlStateNormal];
//传出选择的天数
        if (_delegate && [_delegate respondsToSelector:@selector(timeSelectorType:timeArray:days:)]) {
            [_delegate timeSelectorType:_timeType timeArray:nil days:days];
        }
        [self sk_timeViewClose];
    }
    
}
//确定取消
- (void)cancelOrDetermineAction:(UIButton *)sender {
    
    if (sender.tag == 10000) {
        [self sk_timeViewClose];
        return;
    }
    NSArray *timeArray;
    NSString *days;
    if (_timeType == SKTimeSelectorStartEndType) {
        if (!_startTimeText) {
            [SKHUDManager showErrorWithPrompt:@"请选择开始时间"];
            return;
        }
        if (!_endTimeText) {
            [SKHUDManager showErrorWithPrompt:@"请选择结束时间"];
            return;
        }
        NSDate *startDate = [NSDate date:_startTimeText WithFormat:TIME_FORMAT_TYPE];
        //    时间转换时间戳
        NSTimeInterval startTime = [startDate timeIntervalSince1970];
        NSDate *endDate = [NSDate date:_endTimeText WithFormat:TIME_FORMAT_TYPE];
        //    时间转换时间戳
        NSTimeInterval endTime = [endDate timeIntervalSince1970];
        if (endTime <= startTime) {
            [SKHUDManager showErrorWithPrompt:@"结束时间应该小于开始时间"];
            return;
        }
       timeArray = @[_startTimeText,
                     _endTimeText];
    } else if (_timeType == SKTimeSelectorTodayType) {
        days = @"1";
    } else if (_timeType == SKTimeSelectorThreeType) {
        days = @"3";
    } else if (_timeType == SKTimeSelectorSevenType) {
        days = @"7";
    } else if (_timeType == SKTimeSelectorThirtyType) {
        days = @"30";
    }

    if (sender.tag == TAG_BOTTOM_BUTTON + 1) {
        if (_delegate && [_delegate respondsToSelector:@selector(timeSelectorType:timeArray:days:)]) {
            [_delegate timeSelectorType:_timeType timeArray:timeArray days:days];
        }
    }
    [self sk_timeViewClose];
}



#pragma mark -- show close
- (void)sk_timeViewShow {
    
    [[[UIApplication  sharedApplication] keyWindow] addSubview:self] ;
    [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 / 0.8 options:0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.alpha = 1;
        _backView.frame = CGRectMake(kScreenWidth - SKXFrom6(WidthTimeSelectorView), 0, SKXFrom6(WidthTimeSelectorView), kScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    } completion:^(BOOL finished) {
        
    }];
}
- (void)sk_timeViewClose {
    
    [UIView animateWithDuration:.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.alpha = 0;
        _backView.frame = CGRectMake(kScreenWidth, 0, SKXFrom6(WidthTimeSelectorView), kScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

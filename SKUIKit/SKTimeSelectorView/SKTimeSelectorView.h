//
//  SKTimeSelectorView.h
//  CCDMonitoring
//
//  Created by Sakya on 2017/8/2.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, SKTimeSelectorType) {
    
    //开始和起始时间
    SKTimeSelectorStartEndType = 0,
//    选择今天／
    SKTimeSelectorTodayType = 1,
//    选择三天
    SKTimeSelectorThreeType = 2,
//    选择七天
    SKTimeSelectorSevenType = 3,
//    选择30天
    SKTimeSelectorThirtyType = 4,
};

@protocol SKTimeSelectorViewDelegate <NSObject>


/**
 时间类型

 @param timeType 选择的时间类型
 @param timeArray 输出时间的类型 SKTimeSelectorStartEndType 有开始和起始
 */
- (void)timeSelectorType:(SKTimeSelectorType)timeType
               timeArray:(NSArray *)timeArray
                    days:(NSString *)days;


@end

@interface SKTimeSelectorView : UIView

@property (nonatomic, weak) id<SKTimeSelectorViewDelegate>delegate;

- (void)sk_timeViewShow;
- (void)sk_timeViewClose;
@end

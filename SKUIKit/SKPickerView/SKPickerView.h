//
//  SKPickerView.h
//  UnionProgarm
//
//  Created by Sakya on 17/3/17.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, PickerViewType) {
    
    PickerViewSingleRowType = 1,
    PickerViewDoubleRowType
    
};

@protocol SKPickerViewDelegate <NSObject>

- (void)skpickerViwSelectresults:(NSDictionary *)results;

@end

@interface SKPickerView : UIView

@property (nonatomic, copy)void(^sendSelectStyle)(NSString *selectStr);

//
@property (nonatomic, weak) id<SKPickerViewDelegate>delegate;
/**显示的区县0或是街道1*/
@property (nonatomic, copy) NSString *titleType;

- (instancetype)initWithFrame:(CGRect)frame
                   pickerType:(PickerViewType)pickerType
                   titleTexts:(NSArray *) titleTexts;

- (void)show;
- (void)dissmiss;

/**pickerView标题*/
@property (nonatomic, copy) NSString *titleText;
/**pickerView标题Label*/
@property (nonatomic, strong) UILabel *titleLabel;
/**picker需要显示的数据的数组*/
@property (nonatomic, strong) NSArray *pickerTitleArray;
@end

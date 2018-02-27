//
//  SKAutoAddressPickerView.h
//  GZCanLian
//
//  Created by Sakya on 2017/12/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressAreaModel.h"

typedef NS_OPTIONS(NSInteger, SKAddressPickerViewToolbarStyle) {
    SKAddressPickerViewToolbarNormalStyle = 0,
    SKAddressPickerViewToolbarHtmlStyle = 1,
    SKAddressPickerViewToolbarStatisticsStyle = 2,
    SKAddressPickerViewToolbarOfflineAddStyle = 3
};


@interface SKAutoAddressPickerView : UIView<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
//picker data
@property (nonatomic, copy) void(^areaSelectBlock)(AddressAreaModel *area);
@property (nonatomic, copy) void(^areaSelectFinishBlock)(AddressAreaModel *area);

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) SKAddressPickerViewToolbarStyle toolbarStyle;

- (void)pickerViewAddDataSource:(id)area;
- (void)pickerViewUpdateAddressArea:(AddressAreaModel *)areaModel;
//show
- (void)pickerViewShow;
- (void)pickerViewHide;
@end
@interface AreaSelectCell : UITableViewCell

@end




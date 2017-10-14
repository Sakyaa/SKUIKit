//
//  SKInputPictureView.h
//  DangJian
//
//  Created by Sakya on 2017/10/10.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKInputPictureView : UIView

//输出的数组
@property (nonatomic, strong) NSMutableArray *imageArray;

//选择后需要更新的数组
@property (nonatomic, strong) NSArray *selectArray;

@end

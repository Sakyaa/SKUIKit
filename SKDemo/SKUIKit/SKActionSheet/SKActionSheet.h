//
//  SKActionSheet.h
//  SKDemo
//
//  Created by Sakya on 17/3/18.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletedButtonIndex)(NSInteger Buttonindex);   // 0.取消  1.第一个  2.第二个按钮
typedef void(^CompleteAnimationBlock)(BOOL Complete);

@interface SKActionSheet : UIView


@property (nonatomic,copy)   SeletedButtonIndex ButtonIndex;

- (instancetype)initWithCancelStr:(NSString *)str otherButtonTitles:(NSArray<NSString *> *)Titles AttachTitle:(NSString *)AttachTitle;

- (void)ButtonIndex:(SeletedButtonIndex)ButtonIndex;

- (void)ChangeTitleColor:(UIColor *)color AndIndex:(NSInteger )index;

@end


//
//  AddressAreaModel.m
//  GZCanLian
//
//  Created by Sakya on 2017/12/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "AddressAreaModel.h"
#import <MJExtension/MJExtension.h>

@implementation AddressAreaModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"districts":@"AddressAreaModel"};
}
- (NSString *)parentName {
    if (!_parentName) {
        _parentName = @"请选择";
    }
    return _parentName;
}
@end

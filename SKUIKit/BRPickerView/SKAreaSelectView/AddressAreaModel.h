//
//  AddressAreaModel.h
//  GZCanLian
//
//  Created by Sakya on 2017/12/27.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressAreaModel : NSObject

///全部地区
@property (nonatomic, strong) NSArray *districts;
///父级地区名字
@property (nonatomic, copy) NSString *parentName;
@property (nonatomic, assign) BOOL isSelected;


///地区名字
@property (nonatomic, copy) NSString *name;
///地区父级code
@property (nonatomic, copy) NSString *parentCode;
@property (nonatomic, copy) NSString *administrativeCoding;///
@property (nonatomic, copy) NSString *administrativeName;///


@end

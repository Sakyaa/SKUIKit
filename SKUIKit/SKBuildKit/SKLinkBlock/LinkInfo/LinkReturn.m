//
//  LinkReturn.m
//  LinkBlockProgram
//
//  Created by NOVO on 16/9/23.
//  Copyright © 2016年 NOVO. All rights reserved.
//

#import "LinkReturn.h"

@implementation LinkReturn
- (instancetype)init
{
    self = [super init];
    if (self) {
        _infoType = LinkInfoReturn;
        _returnType = LinkReturnLink;
    }
    return self;
}
- (instancetype)initWithReturnValue:(id)returnValue
{
    if(self = [self init]){
        self.returnValue = returnValue;
    }
    return self;
}
- (instancetype)initWithReturnValue:(id)returnValue returnType:(LinkReturnType)returnType
{
    if(self = [self initWithReturnValue:returnValue]){
        self.returnType = returnType;
    }
    return self;
}
@end

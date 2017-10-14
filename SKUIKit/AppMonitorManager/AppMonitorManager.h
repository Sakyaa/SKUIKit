//
//  AppMonitorManager.h
//  AppMonitorManager
//
//  Created by Sakya on 2017/6/30.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppMonitorManager : NSObject
+ (AppMonitorManager *)shareInstance;


- (NSArray *)getInterfaceBytes;


// 获取当前设备可用内存(单位：MB）
+ (double)appAvailableMemory;
// 获取当前任务所占用的内存（单位：MB）
+ (double)appCurrentUsingMemory;
// 总磁盘容量
+ (float)appTotalDiskSize;
// 可用磁盘容量
+ (float)appAvailableDiskSize;
// 总内存
+ (long long)appTotalMemorySize;
+ (NSString *)stringChangeWithbites:(float)bites;
@end

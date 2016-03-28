//
//  AppUtils.h
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kAppStatus){
    kAppQA = 0,
    kAppDev = 1,
    kAppStore = 2,
};

@interface AppUtils : NSObject

// 提供url升级接口
+ (NSString *)getUrlVersion;
// 提供网络状态，一般屏蔽
+ (NSString *)getNetStatus;
// 提供一些系统信息的接口
+ (NSString *)systemInfo;
@end

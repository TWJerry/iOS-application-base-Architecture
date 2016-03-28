//
//  AppConstants.m
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "AppConstants.h"

#pragma constants
//一般放工程中的一些常量
NSString * const appkey = @"userName";

#pragma HTTP
NSString *const statusCode = @"status";
NSString *const errorMessage = @"message";
NSString *const errorDemoin = @"HTTPDemoin";

//服务器自定义errorCode
NSInteger const errorCode = 1;
NSInteger const tokenCode = 2;
NSInteger const paramsCode = 3;

#pragma HTTPURL
// 一般来说QA和Dev是共享数据，也可有自己的QA版本链接
NSString *const HTTPDev = @"http://api.dev.tete.haodou.com";
NSString *const HTTPQA = @"http://api.dev.tete.haodou.com";
NSString *const HTTPStore = @"http://api.tete.haodou.com";
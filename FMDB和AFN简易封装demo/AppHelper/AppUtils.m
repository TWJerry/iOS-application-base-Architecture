//
//  AppUtils.m
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "AppUtils.h"
#import "AppConstants.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "AFNetworkReachabilityManager.h"
static kAppStatus status = kAppQA;

//以下为接口升级或者部分接口更新时使用
static NSString *kAppUrlVersion = @"v1";
static NSString *kAppUrlVersionUpdate = @"v2";

@implementation AppUtils
+ (kAppStatus)getAppStatus
{
    return status;
}

+ (NSString *)getMainUrl
{
    kAppStatus urlType = [self getAppStatus];
    switch (urlType) {
        case kAppDev:
            return HTTPDev;
            break;
        case kAppQA:
            return HTTPQA;
            break;
        case kAppStore:
            return HTTPStore;
            break;
        default:
            return HTTPDev;
            break;
    }
}

+ (NSString *)getUrlVersion
{
    // 直接在这里修正url版本
    return [NSString stringWithFormat:@"%@/%@",[self getMainUrl],kAppUrlVersion];
}

+ (NSString *)systemInfo
{
    NSString *systemType = [UIDevice currentDevice].model;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSString *uuId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *urlVersion = [NSString stringWithFormat:@"%ld",[self getAppStatus]];
    NSString *clientVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *netStatus = [self getNetStatus];
    NSString *time = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970];
    
    
    // 根据后台需求定义自己的手机信息，方便出错调试。
    return [NSString stringWithFormat:@"%@&%@&%@&%@&%@&%@&%@&%@",systemType,systemName,systemVersion,uuId,clientVersion,urlVersion,netStatus,time];
}

+ (NSString *)getNetStatus
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    if (manager.reachableViaWiFi) {
        return @"WIFI";
    }
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentNetStatus = netInfo.currentRadioAccessTechnology;
    
    // 需要的时候可以拼接上运营商的名字，通过carrier.carrierName可以获取运营商名字，如果拼接，请注意中文字符转义。
    //    CTCarrier *carrier = netInfo.subscriberCellularProvider;
    
    if ([currentNetStatus isEqualToString:CTRadioAccessTechnologyGPRS]|
        [currentNetStatus isEqualToString:CTRadioAccessTechnologyEdge]|
        [currentNetStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return @"2G";
    }else if ([currentNetStatus isEqualToString:CTRadioAccessTechnologyWCDMA]|
              [currentNetStatus isEqualToString:CTRadioAccessTechnologyHSDPA]|
              [currentNetStatus isEqualToString:CTRadioAccessTechnologyHSUPA]|
              [currentNetStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]|
              [currentNetStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]|
              [currentNetStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]
              ){
        return @"3G";
    }else if ([currentNetStatus isEqualToString:CTRadioAccessTechnologyLTE]){
        return @"4G";
    }else {
        return @"other";
    }
}
@end
//
//  UrlUtils.m
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "UrlUtils.h"
#import "AppConstants.h"

@implementation UrlUtils

+ (NSString *)appendRequestUrl:(NSString *)url
{
    return [NSString stringWithFormat:@"%@/%@?%@",[AppUtils getUrlVersion],url,[AppUtils systemInfo]];
}

+ (NSString *)getUserInfoUrl
{
    //这是一个简单的登录接口example。
    return [self appendRequestUrl:@"userInfo/login"];
}
@end

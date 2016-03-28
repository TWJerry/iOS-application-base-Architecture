//
//  UrlUtils.h
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUtils.h"
@interface UrlUtils : NSObject


// 在头文件中定义自己需要的url,建议一次性写完，否则多人添加url接口开发过程中出现冲突。
+ (NSString *)getUserInfoUrl;
@end

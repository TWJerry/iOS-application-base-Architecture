//
//  NSObject+HTTPUtils.m
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "NSObject+HTTPUtils.h"

@implementation NSObject (HTTPUtils)
+ (void)errorMessageWithObject:(NSDictionary *)responseObject error:(NSError *__autoreleasing *)error
{
    TTLog(@"%@",responseObject);
    NSString *value = [responseObject objectForKey:statusCode];
    // 服务器返回成功的参数根据自己后台定义
    if (![value isEqualToString:@"200"]) {
        
        //errorMessage是自己后台返回的错误信息。
        NSString *errorMsg = [responseObject objectForKey:errorMessage];
        NSDictionary *dict = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:errorDemoin code:[value integerValue] userInfo:dict];
    }
}

@end


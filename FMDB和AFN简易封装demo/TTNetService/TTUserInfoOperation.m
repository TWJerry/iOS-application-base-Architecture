//
//  TTUserInfoOperation.m
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTUserInfoOperation.h"
#import "UrlUtils.h"
@implementation TTUserInfoOperation
+ (instancetype)operationWith:(NSString *)userId password:(NSString *)password callBack:(void (^)(id responseObject, NSError *error))callBack
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:userId forKey:@"userId"];
    [dict setValue:password forKey:@"password"];
    
    return [super operationWithMethod:@"POST" urlString:[UrlUtils getUserInfoUrl] params:dict callBack:callBack];
}
@end

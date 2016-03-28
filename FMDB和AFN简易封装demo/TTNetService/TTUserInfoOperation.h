//
//  TTUserInfoOperation.h
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTNetServiceOperation.h"

@interface TTUserInfoOperation : TTNetServiceOperation
+ (instancetype)operationWith:(NSString *)userId password:(NSString *)password callBack:(void (^)(id responseObject,NSError *error))callBack;
@end

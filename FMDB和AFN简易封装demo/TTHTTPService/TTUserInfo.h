//
//  TTUserInfo.h
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TTUserInfoType) {

    TTUserInfoRegist,
    TTUserInfoUpdate,
    TTUserInfoLogin,
};

@interface TTUserInfo : NSObject
+ (void)getUserInfoWith:(NSString *)userId password:(NSString *)password type:(TTUserInfoType)type callBack:(void (^)(id responseObject,NSError *error))callBack;

+ (void)upLoadImage:(UIImage *)image userId:(NSString *)userId password:(NSString *)password callBack:(void (^)(id responseObject,NSError *error))callBack;

@end

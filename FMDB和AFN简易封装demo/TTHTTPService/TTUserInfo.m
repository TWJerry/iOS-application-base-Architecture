//
//  TTUserInfo.m
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTUserInfo.h"
#import "TTHTTPService.h"
#import "UrlUtils.h"
#import "NSObject+HTTPUtils.h"

@implementation TTUserInfo
+ (void)getUserInfoWith:(NSString *)userId password:(NSString *)password type:(TTUserInfoType)type callBack:(void (^)(id responseObject,NSError *error))callBack
{
    // 防止dos攻击，这里一般用MD5计算token，写在最后，token计算方法自行设计
    NSMutableDictionary *dictonary = [NSMutableDictionary dictionary];
    
    [dictonary setValue:userId forKey:@"userId"];
    [dictonary setValue:password forKey:@"password"];
    
    [[TTHTTPService shareService] POST:[UrlUtils getUserInfoUrl] parameters:dictonary success:^ void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
        // 在这里定义一些跟服务器约定的error参数。
        NSError *error;
        [self errorMessageWithObject:responseObject error:&error];
        callBack(responseObject,error);
        
    } failure:^ void(AFHTTPRequestOperation * __nullable operation, NSError * __nonnull error) {
        callBack(nil,error);
    }];
}

+ (void)upLoadImage:(UIImage *)image userId:(NSString *)userId password:(NSString *)password callBack:(void (^)(id, NSError *))callBack
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [[TTHTTPService shareService] POST:[UrlUtils getUserInfoUrl] parameters:nil constructingBodyWithBlock:^ void(id<AFMultipartFormData> __nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"icon" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^ void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
        NSError *error;
        [self errorMessageWithObject:responseObject error:&error];
        callBack(responseObject,error);
    } failure:^ void(AFHTTPRequestOperation * __nullable operation, NSError * __nonnull error) {
        callBack(nil,error);
    }];
}
@end

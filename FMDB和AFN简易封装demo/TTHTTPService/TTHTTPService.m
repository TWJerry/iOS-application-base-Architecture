//
//  TTHTTPService.m
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTHTTPService.h"

@interface TTHTTPService ()

@end
@implementation TTHTTPService
static TTHTTPService *_service;
+(instancetype)shareService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _service = [[self alloc] init];
    });
    return _service;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self startNetWorkMonitoring];
    }
    return self;
}

- (void)startNetWorkMonitoring
{
    [self.reachabilityManager startMonitoring];
    
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 有网的时候做什么操作
    }];
    
    // 显示状态栏上面网络的菊花，不显示菊花直接设置其属性enable为NO即可。
    self.activityManger = [AFNetworkActivityIndicatorManager sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (AFHTTPRequestOperation *)GET:(NSString * __nonnull)URLString parameters:(nullable id)parameters success:(nullable void (^)(AFHTTPRequestOperation * __nonnull, id __nonnull))success failure:(nullable void (^)(AFHTTPRequestOperation * __nullable, NSError * __nonnull))failure
{
    return [super GET:URLString parameters:parameters success:success failure:failure];
}

// post上传图片也可以，直接把image转成data,然后base64，放在参数上就可以
- (AFHTTPRequestOperation *)POST:(NSString * __nonnull)URLString parameters:(nullable id)parameters success:(nullable void (^)(AFHTTPRequestOperation * __nonnull, id __nonnull))success failure:(nullable void (^)(AFHTTPRequestOperation * __nullable, NSError * __nonnull))failure
{
    return [super POST:URLString parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *)POST:(NSString * __nonnull)URLString parameters:(nullable id)parameters constructingBodyWithBlock:(nullable void (^)(id<AFMultipartFormData> __nonnull))block success:(nullable void (^)(AFHTTPRequestOperation * __nonnull, id __nonnull))success failure:(nullable void (^)(AFHTTPRequestOperation * __nullable, NSError * __nonnull))failure
{
    return [super POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure];
}


- (void)cancelAllOperations
{
    [self.operationQueue cancelAllOperations];
}

- (void)cancelOperation:(AFHTTPRequestOperation *)operation
{
    [operation cancel];
}

- (void)networkStatusDidChange:(NSNotification *)notification
{
    // 网络状态变化做啥操作，可重写NSOperationqueue.无网状态下将operation加入到自己的queue中，有网了就可调用，继续执行。
}

- (void)initializeHTTPField
{
    // 在这里统一设置HTTP头域中的一些信息,如果不需要，那么直接不调用就可以
    [self.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    [self.requestSerializer setValue:@"" forHTTPHeaderField:@""];
}

// 重写copy,防止有的小伙伴copy该对象
- (instancetype)copyWithZone:(NSZone *)zone
{
    return _service;
}
@end

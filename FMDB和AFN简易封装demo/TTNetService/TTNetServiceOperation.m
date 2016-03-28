//
//  singleThreadOperation.m
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTNetServiceOperation.h"
#import "NSObject+HTTPUtils.h"
#import "AFHTTPRequestOperation.h"

@interface TTNetServiceOperation ()
@property (nonatomic,strong) AFHTTPResponseSerializer *responseSerializer;
@property (nonatomic,strong,readwrite) NSURLRequest *request;
@end
@implementation TTNetServiceOperation

+ (instancetype)operationWithMethod:(NSString *)method urlString:(NSString *)urlString params:(id)params callBack:(callBack)completion
{
    TTNetServiceOperation *operation = [[[self class] alloc] init];
    
    // 这里根据需要是否计算token，或直接根据参数计算好HTTPBody放到request的HTTPBody中。
    operation.request = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlString parameters:params error:nil];
    //为了方便,直接启动网络，此时main在主线程，由于AFHTTPRequestOperation里面还有异步，所以网络是异步的。
    [operation start];
    return operation;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 看服务器返回的格式，如果AF框架对返回的数据无法解析，那么为AFHTTPResponseSerializer定义一个子类，在子类中添加自己服务器返回的数据解析格式
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

// 直接start启动
- (void)start
{
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }else {
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self main];
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (void)main
{
    // 为线程创建自动释放池，加到NSOperationQueue中在异步。初始化一些网络监控信息，AFNetworkActivityIndicatorManager，AFNetworkReachabilityManager等。最好另外写单例，不直接绑在operation中，一个对象会比较大。
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    @autoreleasepool {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:self.request];
        [operation setCompletionBlockWithSuccess:^ void(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
            
            if (self.isCancelled) {
                return;
            }
            NSError *error;
            [[self class] errorMessageWithObject:responseObject error:&error];
            self.completion(responseObject,error);
        } failure:^void(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
             self.completion(nil,error);
        }];
    }
}

- (BOOL)isFinished
{
    return finished;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return executing;
}
@end

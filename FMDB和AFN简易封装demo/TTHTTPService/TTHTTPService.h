//
//  TTHTTPService.h
//  FMDB和AFN简易封装demo
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
@interface TTHTTPService : AFHTTPRequestOperationManager
@property  (nonatomic,strong) AFNetworkActivityIndicatorManager *activityManger;

+ (instancetype)shareService;
- (void)cancelAllOperations;
- (void)cancelOperation:(AFHTTPRequestOperation *)operation;
@end

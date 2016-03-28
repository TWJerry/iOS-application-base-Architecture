//
//  singleThreadOperation.h
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^callBack)(id responseObject,NSError *error);
@interface TTNetServiceOperation : NSOperation
{
    BOOL finished;
    BOOL executing;
}
@property (nonatomic,copy) callBack completion;
@property (nonatomic,strong,readonly) NSURLRequest *request;

+ (instancetype)operationWithMethod:(NSString *)method urlString:(NSString *)urlString params:(id)params callBack:(callBack)completion;
@end

//
//  NSObject+HTTPUtils.h
//  AFN的一些封装
//
//  Created by mac on 15/12/12.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HTTPUtils)
+ (void)errorMessageWithObject:(NSDictionary *)responseObject error:(NSError **)error;
@end

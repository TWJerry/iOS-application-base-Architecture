//
//  GroupInfo.h
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface GroupInfo : NSObject
@property (nonatomic,copy) NSString *groupId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *numbers;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,strong) UserInfo *userInfo;
@end

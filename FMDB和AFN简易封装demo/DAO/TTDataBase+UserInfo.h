//
//  TTDataBase+UserInfo.h
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTDataBase.h"
#import "UserInfo.h"
@interface TTDataBase (UserInfo)
- (UserInfo *)getUserInfoWithUserId:(NSString *)userId;
- (void)saveUserInfo:(UserInfo *)userInfo withGroupId:(NSString *)groupId;
- (void)saveUserInfos:(NSArray *)userInfos withGroupId:(NSString *)groupId;

// 一对多关系
- (NSArray *)getAllUserInfosWith:(NSString *)groupId;
- (void)updateUserInfo:(UserInfo *)userInfo withGroupId:(NSString *)groupId;
- (void)deleteUserInfoWithUserId:(NSString *)userId;
@end

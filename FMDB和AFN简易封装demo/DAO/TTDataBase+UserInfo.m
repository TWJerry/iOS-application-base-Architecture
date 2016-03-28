//
//  TTDataBase+UserInfo.m
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTDataBase+UserInfo.h"
@implementation TTDataBase (UserInfo)
- (UserInfo *)getUserInfoWithUserId:(NSString *)userId
{
    __block UserInfo *userInfo;
    if (userId == nil) {
        TTLog(@"groupId is %@",userId);
        return nil;
    }
    
    [self.readQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM UserInfo WHERE groupId = ?",userId];
        [self DBErrorHandleWith:db];
        userInfo = [self getObjectWithClass:[UserInfo class] fromResultSets:set];
    }];
    return userInfo;
}

- (void)saveUserInfo:(UserInfo *)userInfo withGroupId:(NSString *)groupId
{
    if (!userInfo) {
        return;
    }
    [self.writeQueue inDatabase:^(FMDatabase *db) {
        int key = [db intForQuery:@"SELECT * FROM UserInfo WHERE userId = ?",userInfo.userId];
        if (key) {
            [db executeUpdate:@"UPDATE UserInfo SET name = ?,age = ?,groupId = ? WHERE userId = ?",userInfo.name,userInfo.age,groupId,userInfo.userId];
        }else {
            [db executeUpdate:@"INSERT INTO UserInfo (userId,name,age,groupId) VALUES (?,?,?,?)",userInfo.userId,userInfo.name,userInfo.age,groupId];
        }
        [self DBErrorHandleWith:db];
    }];

}

// 一对多关系从表取值
- (NSArray *)getAllUserInfosWith:(NSString *)groupId
{
    __block NSArray *array;
    [self.writeQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM UserInfo WHERE groupId = ?",groupId];
        array = [self getObjectsWithClass:[UserInfo class] fromResultSets:rs];
    }];
    
    if ([array count]) {
        return array;
    }
    return nil;
}

// 一对多关系根据外键去从表取值
- (void)updateUserInfo:(UserInfo *)userInfo withGroupId:(NSString *)groupId
{
    [self.writeQueue inDatabase:^(FMDatabase *db) {
        NSString *groupId = [db stringForQuery:@"SELECT * FROM UserInfo WHERE userId = ?",userInfo.userId];
        if (groupId) {
            [db executeUpdate:@"UPDATE UserInfo SET name = ?,age = ?  WHERE userId = ?",userInfo.name,userInfo.age,userInfo.userId];
        }else {
            [db executeUpdate:@"INSERT INTO UserInfo (userId,name,age,groupId) VALUES (?,?,?,?)",userInfo.userId,userInfo.name,userInfo.age,groupId];
        }
        [self DBErrorHandleWith:db];
    }];

}

- (void)deleteUserInfoWithUserId:(NSString *)userId
{
    [self.writeQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM UserInfo WHERE userId = ?",userId];
        [self DBErrorHandleWith:db];
    }];
}

- (void)saveUserInfos:(NSArray *)userInfos withGroupId:(NSString *)groupId
{
    for (UserInfo *info in userInfos) {
        [self saveUserInfo:info withGroupId:groupId];
    }
}
@end

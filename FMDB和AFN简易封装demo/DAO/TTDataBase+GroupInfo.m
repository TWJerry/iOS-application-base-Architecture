
//
//  TTDataBase+GroupInfo.m
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTDataBase+GroupInfo.h"
#import "TTDataBase+UserInfo.h"

@implementation TTDataBase (GroupInfo)
- (GroupInfo *)getGroupInfoWithGroupId:(NSString *)groupId
{
    __block GroupInfo *groupInfo;
    if (groupId == nil) {
        TTLog(@"groupId is %@",groupId);
        return nil;
    }
    
    [self.readQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:@"SELECT * FROM GroupInfo WHERE groupId = ?",groupId];
        [self DBErrorHandleWith:db];
        groupInfo = [self getObjectWithClass:[GroupInfo class] fromResultSets:set];
    }];
    return groupInfo;
}

- (void)saveGroupInfo:(GroupInfo *)groupInfo
{
    if (!groupInfo) {
        return;
    }
    [self.writeQueue inDatabase:^(FMDatabase *db) {
        int key = [db intForQuery:@"SELECT * FROM GroupInfo WHERE groupId = ?",groupInfo.groupId];
        if (key) {
            [db executeUpdate:@"UPDATE GroupInfo SET name = ?,numbers = ?,icon = ? WHERE groupId = ?",groupInfo.name,groupInfo.numbers,groupInfo.icon,groupInfo.groupId];
        }else {
            [db executeUpdate:@"INSERT INTO GroupInfo (groupId,name,numbers,icon,userInfo) VALUES (?,?,?,?,?)",groupInfo.groupId,groupInfo.name,groupInfo.numbers,groupInfo.icon,groupInfo.userInfo];
        }
        [self saveUserInfo:groupInfo.userInfo withGroupId:groupInfo.groupId];
        [self DBErrorHandleWith:db];
    }];
}

- (NSArray *)getAllGroupInfos
{
    __block NSArray *array;
    [self.readQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GroupInfo"];
        [self DBErrorHandleWith:db];
        array = [self getObjectsWithClass:[GroupInfo class] fromResultSets:rs];
    }];
    if ([array count]) {
        return array;
    }else {
        TTLog(@"数据库中没有该记录");
        return nil;
    }
}

- (void)updateGroupInfo:(GroupInfo *)groupInfo
{
    [self.writeQueue inDatabase:^(FMDatabase *db) {
        NSString *groupId = [db stringForQuery:@"SELECT * FROM GroupInfo WHERE groupId = ?",groupInfo.groupId];
        if (groupId) {
            [db executeUpdate:@"UPDATE GroupInfo SET name = ?,icon = ?,numbers = ? WHERE groupId = ?",groupInfo.name,groupInfo.icon,groupInfo.numbers,groupInfo.groupId];
        }else {
            [db executeUpdate:@"INSERT INTO GroupInfo (groupId,name,icon,numbers) VALUES (?,?,?,?)",groupInfo.groupId,groupInfo.name,groupInfo.icon,groupInfo.numbers];
        }
        [self DBErrorHandleWith:db];
    }];
}

- (void)deleteGroupInfoWithGroupId:(NSString *)groupId
{
   [self.writeQueue inDatabase:^(FMDatabase *db) {
       [db executeUpdate:@"DELETE FROM GroupInfo WHERE groupId = ?",groupId];
       [self DBErrorHandleWith:db];
   }];
}

@end

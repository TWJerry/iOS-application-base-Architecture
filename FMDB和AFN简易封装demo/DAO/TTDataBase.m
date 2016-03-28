//
//  TTDataBase.m
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTDataBase.h"
#import <objc/runtime.h>
@interface TTDataBase ()
@property (nonatomic,copy) NSString *DBPath;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) FMDatabaseQueue *queue;
@end
static TTDataBase *dataBase;
@implementation TTDataBase
+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [[self alloc] init];
    });
    
    [dataBase createTables];
    return dataBase;
}

- (FMDatabaseQueue *)readQueue
{
    return [FMDatabaseQueue databaseQueueWithPath:[self getDBFilePath]];
}

- (FMDatabaseQueue *)writeQueue
{
    return [FMDatabaseQueue databaseQueueWithPath:[self getDBFilePath]];
}

- (NSString *)getDBFilePath
{
    if (self.DBPath) {
        return self.DBPath;
    }
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *DBPath = [path stringByAppendingPathComponent:@"TTDataBase.sqlite"];
    
    self.DBPath = DBPath;
    return DBPath;
}

- (void)createTables
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:[self getDBFilePath]]) {
        return;
    };
    self.db = [FMDatabase databaseWithPath:[self getDBFilePath]];
    self.queue = [FMDatabaseQueue databaseQueueWithPath:[self getDBFilePath]];
    if ([self.db open]) {
        //这里本人是直接存得二进制数据，也可以不存userInfo的二进制数据，去掉该字段。因为userInfo放在另外一个表中
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS GroupInfo (groupId TEXT PRIMARY KEY,name TEXT,numbers TEXT,icon TEXT,userInfo BLOB)"];
        [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS UserInfo (userId TEXT PRIMARY KEY,name TEXT,age TEXT,groupId TEXT)"];
        TTLog(@"DBCreateTablesSuccess");
    }else {
        TTLog(@"DBError:%@",[self.db lastErrorMessage]);
    }
}

- (id)getObjectWithClass:(Class)modelClass fromResultSets:(FMResultSet *)rs
{
    [rs close];
    id object = [[modelClass alloc] init];
    NSArray *array = [self getPropertiesWith:modelClass];
    
    if ([rs next]) {
        for (int i = 0; i<[array count]; i++) {
            NSString *columnName = [array objectAtIndex:i];
            id value = [rs objectForColumnName:columnName];
            if (value != [NSNull null]) {
                [object setValue:value forKeyPath:columnName];
            }
        }
        return object;
    }else {
        TTLog(@"数据库中没该记录");
        return nil;
    }
}

- (NSArray *)getObjectsWithClass:(Class)modelClass fromResultSets:(FMResultSet *)rs
{
    [rs close];
    NSMutableArray *objectsArray = [NSMutableArray array];
    NSArray *array = [self getPropertiesWith:modelClass];
    while ([rs next]) {
        id object = [[modelClass alloc] init];
        for (int i = 0; i<[array count]; i++) {
            NSString *columnName = [array objectAtIndex:i];
            id value = [rs objectForColumnName:columnName];
            if (value != [NSNull null]) {
                [object setValue:value forKeyPath:columnName];
            }
        }
        [objectsArray addObject:object];
    }
    return objectsArray;
}

// 运行时获取成员变量然后根据变量名去数据库的查询结果中取值
- (NSArray *)getPropertiesWith:(Class)modelClass
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int num;
    Ivar *vars = class_copyIvarList(modelClass, &num);
    
    for (int i = 0; i< num; i++) {
        Ivar var = vars[i];
        
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(var)];
        [array addObject:[propertyName substringFromIndex:1]];
    }
    return array;
}

- (void)DBErrorHandleWith:(FMDatabase *)db
{
    if ([db hadError]) {
        TTLog(@"%@ %@",NSStringFromSelector(_cmd),db.lastErrorMessage);
        if (DEBUG) {
            [NSException raise:@"BEException" format:@"%@",db.lastErrorMessage];
        }
    }
}
@end

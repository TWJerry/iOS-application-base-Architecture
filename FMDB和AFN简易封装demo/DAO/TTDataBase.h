//
//  TTDataBase.h
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface TTDataBase : NSObject
+(instancetype)share;
@property (nonatomic,strong) FMDatabaseQueue *readQueue;
@property (nonatomic,strong) FMDatabaseQueue *writeQueue;


- (id)getObjectWithClass:(Class)modelClass fromResultSets:(FMResultSet *)rs;
- (NSArray *)getObjectsWithClass:(Class)modelClass fromResultSets:(FMResultSet *)rs;

- (void)DBErrorHandleWith:(FMDatabase *)db;
@end

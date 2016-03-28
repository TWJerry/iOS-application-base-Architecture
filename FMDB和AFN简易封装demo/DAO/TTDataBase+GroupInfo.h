//
//  TTDataBase+GroupInfo.h
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import "TTDataBase.h"
#import "GroupInfo.h"
@interface TTDataBase (GroupInfo)
- (GroupInfo *)getGroupInfoWithGroupId:(NSString *)groupId;
- (void)saveGroupInfo:(GroupInfo *)groupInfo;
- (NSArray *)getAllGroupInfos;
- (void)updateGroupInfo:(GroupInfo *)groupInfo;
- (void)deleteGroupInfoWithGroupId:(NSString *)groupId;
@end

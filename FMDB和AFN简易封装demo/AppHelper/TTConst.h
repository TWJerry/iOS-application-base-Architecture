//
//  Header.h
//  FMDB的一些封装
//
//  Created by mac on 15/12/9.
//  Copyright (c) 2015年 汤威. All rights reserved.
//


#ifdef DEBUG
#define TTLog(s,...) NSLog(@"Debug:< %@:(%d) > %@",[NSString stringWithUTF8String:__FILE__],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__])
#else
#define TTLog(s,...)
#endif


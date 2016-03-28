//
//  NSArray+Extension.m
//  运行时的研究
//
//  Created by mac on 15/11/18.
//  Copyright (c) 2015年 汤威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@implementation NSObject (Extension)

+ (void)switchOriginSelector:(SEL)originSelector withSelector:(SEL)selector OnClass:(Class)class
{
    Method originMethod  = class_getInstanceMethod(class, originSelector);
    
    Method method = class_getInstanceMethod(class, selector);
    
    method_exchangeImplementations(originMethod, method);
}
@end

@implementation NSArray (Extension)
+ (void)load
{
    [self switchOriginSelector:@selector(objectAtIndex:) withSelector:@selector(objAtIndex:) OnClass:NSClassFromString(@"__NSArrayI")];
}

- (id)objAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objAtIndex:index];
    }
    TTLog(@"数组越界");
    return nil;
}

// 打印服务器返回的数据直接是中文。
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}
@end

@implementation NSMutableArray (Extension)
+ (void)load
{
    [self switchOriginSelector:@selector(addObject:) withSelector:@selector(addObj:) OnClass:NSClassFromString(@"__NSArrayM")];
    [self switchOriginSelector:@selector(objectAtIndex:) withSelector:@selector(objAtIndex:) OnClass:NSClassFromString(@"__NSArrayM")];
}

- (NSArray *)addObj:(id)obj
{
    if (obj) {
       return [self addObj:obj];
    }
    TTLog(@"添加对象为空");
    return self;
}

- (id)objAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objAtIndex:index];
    }
    TTLog(@"数组越界");
    return nil;
}
@end

@implementation NSDictionary (Extension)
+ (void)load
{
    [self switchOriginSelector:@selector(objectForKey:) withSelector:@selector(objForKey:) OnClass:NSClassFromString(@"__NSDictionaryI")];
}

- (id)objForKey:(id)aKey
{
    if (nil == aKey) {
        TTLog(@"key值为空");
        return nil;
    }
    return [self objForKey:aKey];
}

// 打印服务器返回的数据直接是中文。
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end

@implementation NSMutableDictionary (Extension)
+ (void)load
{
    [self switchOriginSelector:@selector(setObject:forKey:) withSelector:@selector(setObj:forKey:) OnClass:NSClassFromString(@"__NSDictionaryM")];
    [self switchOriginSelector:@selector(objectForKey:) withSelector:@selector(objForKey:) OnClass:NSClassFromString(@"__NSDictionaryM")];
    [self switchOriginSelector:@selector(removeObjectForKey:) withSelector:@selector(removeObjForKey:) OnClass:NSClassFromString(@"__NSDictionaryM")];
}

- (void)setObj:(id)obj forKey:(id<NSCopying>)key
{
    if (nil == key) {
        TTLog(@"插入的key值为空");
        return;
    }
    [self setObj:obj forKey:key];
}

- (id)objForKey:(id)aKey
{
    if (nil == aKey) {
        TTLog(@"取值的key值为空");
        return nil;
    }
    return [self objForKey:aKey];
}

- (void)removeObjForKey:(id)aKey
{
    if (nil == aKey) {
        TTLog(@"删除key值为空");
        return;
    }
    [self removeObjForKey:aKey];
}

@end


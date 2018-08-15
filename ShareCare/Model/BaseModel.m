//
//  BaseModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (instancetype)init{        
    if (self = [super init]) { 
        
        _idValue = @"0";
       return self;     
    }       
    return nil;
}







/* 根据数据字典返回model */
+ (id)modelWithDictionary:(NSDictionary *)dic {
    __strong Class model = [[[self class] alloc] init];
    [model setValuesForKeysWithDictionary:[self deleteNullFrom:dic]];
    return model;
}
+ (NSDictionary *)deleteNullFrom:(NSDictionary *)dictionary{
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dictionary.allKeys) {
        if ([[dictionary objectForKey:keyStr] isEqual:[NSNull null]]) {
            
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else{
            [mutableDic setObject:[dictionary objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}
//-(instancetype)initWithDict:(NSDictionary *)dict{
//    if (self = [super init]) {
//        //使用kvc(BOOL 和 int 类型kvc也可以实现转化)
//        [self setValuesForKeysWithDictionary:dict];
//    }
//    return self;
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{  
    if ([key isEqualToString:@"id"]) {
        _idValue = value;
    }
}



/**
 *  对象转换为字典
 * 
 *
 *  @return 转换后的字典
 */
- (NSDictionary*)convertToDictionary{ 
    return [ self convertToDictionaryFrom:self];  
}
- (NSDictionary *)convertToDictionaryFrom:(id)obj{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    
    objc_property_t *props = class_copyPropertyList([obj class], &propsCount);
    
    for(int i = 0;i < propsCount; i++) {
        
        objc_property_t prop = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        id value = [obj valueForKey:propName];
        if(value == nil) {
            
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value];
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}
- (id)getObjectInternal:(id)obj {
    
    if([obj isKindOfClass:[NSString class]]
       ||
       [obj isKindOfClass:[NSNumber class]]
       ||
       [obj isKindOfClass:[NSNull class]]) {
        
        return obj;
        
    }
    if([obj isKindOfClass:[NSArray class]]) {
        
        NSArray *objarr = obj;
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int i = 0; i < objarr.count; i++) {
            
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
        }
        return arr;
    }
    if([obj isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *objdic = obj;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString *key in objdic.allKeys) {
            
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
        }
        return dic;
    }
    return [self convertToDictionaryFrom:obj];
    
}
 



@end

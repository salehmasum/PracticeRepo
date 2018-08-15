//
//  DKDevice.m
//  HZWBridge
//
//  Created by 朱明 on 17/5/9.
//  Copyright © 2017年 Shanghai Seari Intelligent System Co., Ltd. Xi'an Inst. All rights reserved.
//

#import "DKDevice.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation DKDevice

+ (instancetype)instatnce{
    static DKDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[DKDevice alloc] init];
    });
    return device;
}

+ (NSString *)keyDeviceUUID{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)UUIDString{ 
    NSString * strUUID = (NSString *)[KeyChainStore load:[self keyDeviceUUID]];
    
    //首次执行该方法时，uuid为空
 //   if ([strUUID isEqualToString:@""] || !strUUID)
    {
        
        //生成一个uuid的方法
        strUUID = [self createMacAddress];//[[UIDevice currentDevice].identifierForVendor UUIDString]; 
        //将该uuid保存到keychain
        [KeyChainStore save:[self keyDeviceUUID] data:strUUID];
    } 
    return strUUID;
}

+ (NSString *)createMacAddress {
    static int kNumber = 17;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    NSInteger tempIndex = 2;
    for (int i = 0; i < kNumber; i++) {
        if (i == tempIndex) {
         //   [resultStr appendString:@":"];
            tempIndex = tempIndex+3;
        }else{
            unsigned index = rand() % [sourceStr length];
            NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
            [resultStr appendString:oneStr];
        }
        
    }
    return resultStr;
}


@end

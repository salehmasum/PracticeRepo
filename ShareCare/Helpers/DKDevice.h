//
//  DKDevice.h
//  HZWBridge
//
//  Created by 朱明 on 17/5/9.
//  Copyright © 2017年 Shanghai Seari Intelligent System Co., Ltd. Xi'an Inst. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import "KeyChainStore.h"

@interface DKDevice : NSObject

+ (NSString *)UUIDString;
@end

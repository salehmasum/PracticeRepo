//
//  LoginHttp.h
//  ShareCare
//
//  Created by 朱明 on 2018/2/2.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LoginBlock)(BOOL result);

@interface LoginHttp : NSObject

+ (void)loginForState:(LoginState)state loginBlock:(LoginBlock)loginBlock;
@end

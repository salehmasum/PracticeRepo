//
//  NotificationHelper.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
@interface NotificationHelper : NSObject
+ (void)registerLocalNotification:(MessageModel *)message;
@end

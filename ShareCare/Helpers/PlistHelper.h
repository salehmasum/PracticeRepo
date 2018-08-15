//
//  PlistHelper.h
//  ShareCare
//
//  Created by 朱明 on 2018/4/25.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistHelper : NSObject

+ (void)savePopular:(NSDictionary *)object;
+ (void)saveEleCare:(NSArray *)list;
+ (void)saveBabysitting:(NSArray *)list;
+ (void)saveEvent:(NSArray *)list;

+ (NSDictionary *)localPopular;
+ (NSArray *)localEleCareList;
+ (NSArray *)localBabysittingList;
+ (NSArray *)localEventList;

@end

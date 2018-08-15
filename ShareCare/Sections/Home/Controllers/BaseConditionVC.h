//
//  BaseConditionVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConditonSelectedDelegate <NSObject>

@optional

//位置选择
- (void)conditionLocationAnywhere;
- (void)conditionLocationNearby;
- (void)conditionLocationAddress:(NSString *)address lat:(double)lat lon:(double)lon;

//服务类型选择
- (void)conditionType:(ShareCareType)type;

//时间选择
- (void)conditionAnyTime;
- (void)conditionTonight;
- (void)conditionSelectedTime:(NSString *)timeString andDate:(NSDate *)date;
- (void)conditionSelectedYear:(NSInteger)year month:(NSInteger)mongth day:(NSInteger)day;

@end

@interface BaseConditionVC : UIViewController

@property (assign, nonatomic) id<ConditonSelectedDelegate>delegate;

@end

//
//  HomeTableViewVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCell.h"
#import "JPAnimationTool.h" 
#import "ResponseModel.h"
#import "BaseTableViewController.h"
#import "PlistHelper.h"

@protocol HomeTableViewDidScrollDelegate
- (void)homeTableViewDidScrollUpwardDirection;
@end

@interface HomeTableViewVC : BaseTableViewController<FavoriteDelegate>

//@property(assign,nonatomic) int locationType;//0->nearby 1->anywhere 2->location
//@property(assign,nonatomic) double addressLon;
//@property(assign,nonatomic) double addressLat;
//@property(assign,nonatomic) int careType;
@property(assign,nonatomic) BOOL conditionEnable;
//@property(strong,nonatomic) NSString *time;
//time，例如：2017-12-04T15:00:00，传0时表示Anytime，tonight：传当天下午18:00:00

@property(strong,nonatomic) NSDictionary *searchCondition;
@property(assign,nonatomic) id<HomeTableViewDidScrollDelegate> delegate;
//@property(strong,nonatomic) NSDictionary *paraments;
- (NSDictionary *)paramentsFormat:(id)obj;
- (void)refresh:(NSNotification*) notification;
@end

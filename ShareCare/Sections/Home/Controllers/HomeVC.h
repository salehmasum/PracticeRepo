//
//  HomeVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseVC.h"

@interface HomeVC : BaseVC


@property(assign,nonatomic) int locationType;//0->nearby 1->anywhere 2->location
@property(assign,nonatomic) double addressLon;
@property(assign,nonatomic) double addressLat;
@property(assign,nonatomic) int careType;
@property(assign,nonatomic) BOOL conditionEnable;
@property(assign,nonatomic) BOOL isTonight;
@property(assign,nonatomic) int timeType;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *address;
//time，例如：2017-12-04T15:00:00，传0时表示Anytime，tonight：传当天下午18:00:00

@property(strong,nonatomic) NSDictionary *searchCondition;
@end

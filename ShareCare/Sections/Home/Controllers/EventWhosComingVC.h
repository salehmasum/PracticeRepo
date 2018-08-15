//
//  EventWhosComingVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/3.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "WhosComingVC.h"
#import "EventModel.h"
#import "NewChildrenTableVC.h"

@interface EventWhosComingVC : WhosComingVC

@property (strong, nonatomic) NSString *priceStr;
@property (strong, nonatomic) NSString *locationStr;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSMutableSet *childrens;

- (void)addChildren;
@end

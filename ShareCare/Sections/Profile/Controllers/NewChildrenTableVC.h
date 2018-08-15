//
//  NewChildrenTableVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"

@protocol AddChildrenDelegate

- (void)reloadChildrens:(NSArray *)childrens;

@end

@interface NewChildrenTableVC : UITableViewController
@property (strong, nonatomic) NSMutableArray *childrens;
@property (assign, nonatomic) id<AddChildrenDelegate> delegate;
@end

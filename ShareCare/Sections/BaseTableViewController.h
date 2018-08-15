//
//  BaseTableViewController.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseModel.h"



@interface BaseTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
//UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UILabel *lbNoData;
//@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) PageModel *pageModel;
@property (strong, nonatomic) NSString *api;
@property (strong, nonatomic) id object;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) BOOL requestIsLoading;


@property (strong, nonatomic) id paraments;
@property (assign, nonatomic) HTTPMethod httpMethod;

- (id)convertObjectWithObject:(id)object;
- (void)handleResponse:(id)response;
- (void)resetUI;

-(void)refreshStateChange:(UIRefreshControl *)control;
- (void)loadPage:(NSInteger)page;
- (void)search;
@end

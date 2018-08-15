//
//  BaseTableViewController.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseTableViewController.h"
#import "Masonry.h"

@interface BaseTableViewController (){
    UIView *_noDataView;
}

@end

@implementation BaseTableViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.tableView];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self.view);
//    }];
    
    
    [self.view addSubview:self.tableView];
    
    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 400)];
    self.lbNoData = [[UILabel alloc] initWithFrame:_noDataView.bounds];
    self.lbNoData.textColor = TX_RGBA(90, 90, 90, 0.5);
    self.lbNoData.font = TX_BOLD_FONT(30);
    self.lbNoData.text = @"No listing available";
    self.lbNoData.textAlignment = NSTextAlignmentCenter;
    [_noDataView addSubview:self.lbNoData];
     
    [self setupRefresh];
    
    USERDEFAULT_SET(@"refresh_time", [NSDate date]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidNotLoginNotification:) name:@"applicationDidNotLoginNotification" object:nil];
    
     
}
- (void)applicationDidBecomeActiveNotification:(id)notification{
//    NSDate *refresh_time = [[NSUserDefaults standardUserDefaults] objectForKey:@"refresh_time"];
//    NSInteger seconds = [[NSDate date] timeIntervalSince1970]-[refresh_time timeIntervalSince1970];
//    if (seconds > 5) {
//        [self loadPage:0];
//    }
}
//NSInteger seconds = [_endDate timeIntervalSince1970]-[_startDate timeIntervalSince1970];
- (void)applicationDidNotLoginNotification:(NSNotification *)notification{ 
    [self.refreshControl endRefreshing];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (HTTPMethod)httpMethod{
    return HTTPMethodGET;
}
/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
     [self.refreshControl beginRefreshing];
    [self refreshStateChange:self.refreshControl];
     
}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    
    self.pageModel = [[PageModel alloc] init];
    [self loadPage:self.pageModel.number];
}

- (void)loadPage:(NSInteger)page{
    if (self.api == nil) return;
    
    USERDEFAULT_SET(@"refresh_time", [NSDate date]);
    
    [self.refreshControl beginRefreshing];
//    if (page == 0) {
//        self.dataSource = [NSMutableArray array];
//        [self.tableView reloadData];
//        self.tableView.tableHeaderView = [UIView new];
//    }
  //  self.pageNumber = page;
    _requestIsLoading = YES;
    __block __weak typeof(self) weakSelf = self;
    [ShareCareHttp requestHTTPMethod:self.httpMethod 
                                 API:[NSString stringWithFormat:@"%@%@",self.api,PAGEABLE_STRINGFORMAT(page)] 
                       withParaments:self.paraments 
                    withSuccessBlock:^(id response) {
                        //*分页处理
                        [weakSelf handleResponse:response]; 
                       
                        [SVProgressHUD dismiss];
                        [self.refreshControl endRefreshing];
                    } withFailureBlock:^(NSString *error) {
                        [weakSelf resetUI];
                        // 3. 结束刷新
                        [self.refreshControl endRefreshing];
                        _requestIsLoading = NO;
                        [SVProgressHUD dismiss];
                    }];
}


- (NSString *)api{
  //  [SVProgressHUD showErrorWithStatus:@"未设置API"];
    return nil;
}   
- (id)paraments{
    return nil;
}

- (void)handleResponse:(id)response{
    if ([response isKindOfClass:[NSDictionary class]]) {
        //*分页处理
        self.pageModel= [PageModel modelWithDictionary:response];
        if (self.pageModel.first) [self.dataSource removeAllObjects];
        for (NSDictionary *dic in self.pageModel.content) {
            [self.dataSource addObject:[self convertObjectWithObject:dic]];
        } 
    }else{
        self.dataSource = [NSMutableArray array];
        if ([response isKindOfClass:[NSArray class]]) {
            for (id obj in response) {
                [self.dataSource addObject:[self convertObjectWithObject:obj]];
            } 
        }
    }
    [self resetUI];
    [self.tableView reloadData];
    // 3. 结束刷新
    [self.refreshControl endRefreshing];
    _requestIsLoading = NO;
}



- (void)resetUI{
    if (self.dataSource.count == 0) {
        self.tableView.tableHeaderView = _noDataView;
    }else{
        self.tableView.tableHeaderView = [UIView new];
    }
}
- (id)convertObjectWithObject:(id)object{
    return object;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = [indexPath row];
    /*
     * _NumberOfUserRequestData 是当前你请求成功了多少页的数据。
     * _NumberOfOption 是数据的总页数。
     * 该if语句判断是否还有可以刷新的数据
     */
    
    NSLog(@"%ld",indexPath.row);
    
    if (!_pageModel.last && self.dataSource.count>=kPageSize &&!_requestIsLoading &&row>=self.dataSource.count-3) {
        [self loadPage:self.pageModel.nextNumber];
    }
    
//    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView  
{  
//    CGFloat height = scrollView.frame.size.height;  
//    CGFloat contentOffsetY = scrollView.contentOffset.y;  
//    CGFloat bottomOffset = scrollView.contentSize.height - contentOffsetY;  
//    
//    
//    NSLog(@"%f",bottomOffset);
//    if (bottomOffset <= height)  
//    {  
//        //在最底部  
//        if (!_pageModel.last && self.dataSource.count>kPageSize && !_requestIsLoading) {
//            [self refreshStateChange:nil];
//        }
//    }  
} 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

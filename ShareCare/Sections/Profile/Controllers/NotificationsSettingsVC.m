//
//  NotificationsSettingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NotificationsSettingsVC.h"
#import "NotificationsSettingCell.h"
#import "NotificationModel.h"

@interface NotificationsSettingsVC ()<NotificationSettingDelegate>{
    NSMutableDictionary *_statusDic;
    BOOL _isLoading;
}
@end

@implementation NotificationsSettingsVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Notifications";
    _isLoading = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationsSettingCell" bundle:nil] forCellReuseIdentifier:@"NotificationsSettingCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
   // self.tableView.hidden = YES;
    _statusDic = [NSMutableDictionary dictionary];
    _dataSource = @[@[@{@"title":@"Messages",
                        @"desc":@"From EleCarer’s and Babysitter’s ",
                        @"key":@"pMessageStatus"},
                      @{@"title":@"Booking Updates",
                        @"desc":@"Requests, confirmations, changes and more",
                        @"key":@"pBookingUpdates"},
                      @{@"title":@"Account Activity",
                        @"desc":@"Changes made to your account",
                        @"key":@"pAccountActivity"},
                      @{@"title":@"Other",
                        @"desc":@"Feature updates and more",
                        @"key":@"pOtherStatus"}],
                    @[@{@"title":@"Messages",
                        @"desc":@"From EleCarer’s and Babysitter’s ",
                        @"key":@"tMessageStatus"},
                      @{@"title":@"Booking Updates",
                        @"desc":@"Requests, confirmations, changes and more",
                        @"key":@"tBookingUpdates"},
                      @{@"title":@"Other",
                        @"desc":@"Feature updates and more",
                        @"key":@"tOtherStatus"}]];
    
    [self queryNotificationStatus];
}

- (void)queryNotificationStatus{
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    
   // NSString *api =[NSString stringWithFormat:@"%@%ld?",API_MESSAGE_STATUS,self.roleType];
    [ShareCareHttp GET:API_MESSAGE_STATUS withParaments:@[] withSuccessBlock:^(id response) {
        
        _statusDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)response];
        
       // self.tableView.hidden = NO;
        
        _isLoading = NO;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count * !_isLoading;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *items = _dataSource[section];
    return items.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 40)];
    headerView.backgroundColor = COLOR_WHITE;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27, 0, TX_SCREEN_WIDTH-54, 40)];
    label.textColor = TX_RGB(136, 136, 136);
    label.font = TX_BOLD_FONT(20);
    label.text = section?@"Email Notifications":@"Push Notifications";
    [headerView addSubview:label];
    
    UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(27, 39, TX_SCREEN_WIDTH-54, 1)];
    image.image = [UIImage imageNamed:@"line"];
    [headerView addSubview:image];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70*TX_SCREEN_OFFSET;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Push Notifications";
            break;
            
        case 1:
            return @"Text Message Notifications";
            break; 
        default:
            break;
    }
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationsSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationsSettingCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    NSArray *items = _dataSource[indexPath.section];
    cell.lbTitle.text = items[indexPath.row][@"title"];
    cell.lbDesc.text = items[indexPath.row][@"desc"];
    cell.switchView.on = [_statusDic[items[indexPath.row][@"key"]] boolValue];
    cell.key = items[indexPath.row][@"key"];
    cell.delegate = self;
    return cell;
}

- (void)resetNotificationStatus:(BOOL)status forKey:(NSString *)key withSwitch:(UISwitch *)switchView{
    NSLog(@"%@=%d",key,status);
    
 //   [switchView setOn:!status]; 
    [_statusDic setObject:[NSString stringWithFormat:@"%d",status] forKey:key];
    
    [ShareCareHttp POST:API_MESSAGE_SWITCH_STATUS 
          withParaments:_statusDic 
       withSuccessBlock:^(id response) {
        
     //   [switchView setOn:status]; 
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        [_statusDic setObject:[NSString stringWithFormat:@"%d",!status] forKey:key];
        [self.tableView reloadData];
    }];
}

@end

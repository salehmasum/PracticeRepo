//
//  BaseProfileTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseProfileTableVC.h" 
#import "ProfileFunctionCell.h"
#import "ViewController.h" 


@interface BaseProfileTableVC (){ 
}
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *editProfileLabel;
@property (strong, nonatomic) UIImageView *headImageView;
@end

@implementation BaseProfileTableVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  //  [self getProfile];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ProfileFunctionCell  class]) bundle:nil] forCellReuseIdentifier:@"profile"];
     
     self.tableView.tableHeaderView = self.headerView; 
    self.tableView.tableFooterView = [UIView new];
         
}

- (void)editProfile:(id)sender{
    
}
- (void)settings:(id)sender{
    SettingsTableVC *settingVC  = [[SettingsTableVC alloc] init];
    settingVC.title = @"Settings";
    settingVC.roleType = self.roleType;
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (UIView *)headerView{
    if (!_headerView) {
        CGFloat height = 170*TX_SCREEN_OFFSET;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, height)];
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TX_SCREEN_WIDTH-(96*TX_SCREEN_OFFSET)-27, 50, 96*TX_SCREEN_OFFSET, 96*TX_SCREEN_OFFSET)];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = CGRectGetHeight(_headImageView.frame)/2.0; 
        _headImageView.userInteractionEnabled = NO;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(_headImageView.frame), CGRectGetMinX(_headImageView.frame)-40, 40)];
        _nameLabel.font = TX_BOLD_FONT(28);
        [_headerView addSubview:_nameLabel];
        
        
        _editProfileLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_nameLabel.frame), CGRectGetMaxX(_headImageView.frame)-30, 40)];
        _editProfileLabel.font = TX_FONT(14);
        _editProfileLabel.textColor = COLOR_GRAY;
        [_headerView addSubview:_editProfileLabel];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _headerView.bounds;
        [_headerView addSubview:button];
        [button addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}
- (void)getProfile{
    __weak typeof(self) weakself = self;
    NSArray *array = @[kUSER_TOKEN]; 
    [ShareCareHttp GET:API_USER withParaments:array withSuccessBlock:^(id response) { 
        NSLog(@"%@",response);
        NSDictionary *result = response[@"userInfoDto"]; 
        ProfileModel *model = [ProfileModel modelWithDictionary:result];
       // USERDEFAULT_SET(@"email", response[@"email"]);
        USERDEFAULT_SET(@"userId", response[@"id"]);
        
        USERDEFAULT_SET(@"userName", response[@"userName"]);   
        USERDEFAULT_SET(@"fullName", response[@"userInfoDto"][@"fullName"]); 
        USERDEFAULT_SET(@"userIcon", response[@"userInfoDto"][@"userIcon"]);  
        
        USERDEFAULT_SET(@"hashPassword", response[@"hashPassword"]);
        
     //   NSDictionary *result = response[@"userInfoDto"]; 
        weakself.profileModel = [ProfileModel modelWithDictionary:result];
        weakself.profileModel.name = response[@"userName"];
        [weakself initData];
    } withFailureBlock:^(NSString *error) {
      //  [SVProgressHUD showErrorWithStatus:error]; 
    }];
}

- (void)initData{
    _nameLabel.text = kUSER_USERNAME;
    _editProfileLabel.text = @"Edit profile";
    
    NSString *userIcon = kUSER_USERICON;
    NSLog(@"%@",URLStringForPath(userIcon));
    [_headImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                   placeholderImage:kDEFAULT_HEAD_IMAGE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90*TX_SCREEN_OFFSET;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profile" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.nameLabel.text = self.dataSource[indexPath.row][@"name"];
    cell.icon.image = [UIImage imageNamed:self.dataSource[indexPath.row][@"icon"]];
    cell.nameLabel.textColor = indexPath.row==0?COLOR_BLUE:COLOR_GRAY;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL selector = NSSelectorFromString(self.dataSource[indexPath.row][@"selector"]); 
    if ([self respondsToSelector:selector]) { 
        [self performSelector:selector withObject:nil];
    }
}   


@end

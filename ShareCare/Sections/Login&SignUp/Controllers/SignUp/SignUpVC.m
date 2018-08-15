//
//  SignUpVC.m
//  ShareCare
//
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SignUpVC.h"
#import "SignUpCell.h"
#import "NotificationInitVC.h"
#import "BeforeJoinVC.h"

#define SIGNUP_CELL_IDENTIFIER @"signCell"

@interface SignUpVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataSource;
    NSMutableDictionary *_parameters;
}
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation SignUpVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  [self.tableView registerClass:[SignUpCell class] forCellReuseIdentifier:SIGNUP_CELL_IDENTIFIER];
    
    _parameters = [NSMutableDictionary dictionary];
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.tableFooterView = [self footView];
    self.bgImageView.image = [UIImage imageNamed:MAIN_BACKGROUND_IMAGENAME];
    _dataSource = @[@{@"title":CustomLocalizedString(@"Full Name", @"signup"),
                      @"key":@"name",
                      @"secureTextEntry":@0,
                      @"test":@"test"
                      },
                    @{@"title":CustomLocalizedString(@"Email", @"signup"),
                      @"key":@"email",
                      @"secureTextEntry":@0,
                      @"test":@"test@126.com"},
                    @{@"title":CustomLocalizedString(@"Password", @"signup"),
                      @"key":@"password",
                      @"secureTextEntry":@1,
                      @"test":@"123456"},
                    @{@"title":CustomLocalizedString(@"Confirm Password", @"signup"),
                      @"key":@"confirm_password",
                      @"secureTextEntry":@1,
                      @"test":@"123456"}];
    
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height+100, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkInputAvalibe{
    
    if (![_parameters[@"name"] length]) {
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Invalid Full name", @"login")];
        return NO;
    }
    
    if (![Util validateEmail:_parameters[@"email"]]) {
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Invalid email address", @"login")];
        return NO;
    }
    
    NSString *pwsd = _parameters[@"password"];
    
    if (pwsd.length == 0) {
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Invalid password", @"login")];
        return NO;
    } 
    
    if (pwsd.length<MIN_CHARACTERS) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"The password  length is not less than %d characters",MIN_CHARACTERS]];
        return NO;
    } 
    
    if (![_parameters[@"password"] isEqualToString:_parameters[@"confirm_password"]]) {
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Your confirmed password and new password do not match", @"login")];
        return NO;
    }
    return YES;
}
- (void)showAlertViewControllerToFaceBook:(BOOL)facebook{
    if (_alertVC == nil) {
        _alertVC = [[RigisterAlertViewController alloc] init];
        _alertVC.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:_alertVC];
        _alertVC.view.frame = self.view.bounds;
    }
    
    __weak typeof(self) weakSelf = self;
    [_alertVC showAlertInview:self.view goBack:^{
        NSLog(@"点击取消");
    } continueClick:^{
        
        if (!facebook) { 
            [weakSelf requestRegister];
        }
        
        
    }];
}

- (void)confirmAction:(id)sender{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
 //   [self pushNextViewController]; return;
    if (![self checkInputAvalibe]) return;
      
    [self showAlertViewControllerToFaceBook:NO];
    
    
}
-(void)requestRegister{
    __weak typeof(self) weakself = self;
    
    [SVProgressHUD showWithStatus:TEXT_LOADING];   
    
    NSDictionary *dic =@{@"userName":_parameters[@"name"],
                         @"email":_parameters[@"email"],
                         @"password":_parameters[@"password"],
                         @"userId":@"",
                         @"userIcon":@"",
                         @"telephone":@"",
                         @"loginType":@"0",
                         };
    [ShareCareHttp POST:API_REGISTER withParaments:dic withSuccessBlock:^(id response) {
        [weakself pushNextViewController];
        
        
        USERDEFAULT_SET(@"email", _parameters[@"email"]);
        //      USERDEFAULT_SET(@"userId", response[@"id"]);
        USERDEFAULT_SET(@"userName", response[@"userName"]); 
        USERDEFAULT_SET(@"hashPassword", response[@"hashPassword"]);
        USERDEFAULT_SET(@"password", _parameters[@"password"]);
        
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
    }]; 
}


- (void)pushNextViewController{
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    NotificationInitVC *notifyVC = (NotificationInitVC *)[board instantiateViewControllerWithIdentifier: @"NotificationInitVC"];
    [self.navigationController pushViewController:notifyVC animated:YES];
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*TX_SCREEN_OFFSET;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SignUpCell *cell = [SignUpCell cellWithTableView:tableView identifier:SIGNUP_CELL_IDENTIFIER];
    cell.label.text = _dataSource[indexPath.row][@"title"]; 
    id secureTextEntry = _dataSource[indexPath.row][@"secureTextEntry"];
    cell.textField.secureTextEntry = [secureTextEntry boolValue];
    
    NSString *key =  _dataSource[indexPath.row][@"key"];
    if ([key isEqualToString:@"email"]) {
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }else{
        cell.textField.keyboardType = UIKeyboardTypeDefault;
    }
    cell.inputTextBlock = ^(NSString *text) {
        [_parameters setObject:text forKey:_dataSource[indexPath.row][@"key"]];
    };
    return cell;
}




- (UIView *)headerView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 50*TX_SCREEN_OFFSET)]; 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, TX_SCREEN_WIDTH, 40)];
    label.font = TX_BOLD_FONT(32);
    label.textColor = COLOR_WHITE;
    label.text = CustomLocalizedString(@"Sign Up", @"signup");
    label.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:label];
    return headerView; 
}

- (UIView *)footView{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 70*TX_SCREEN_OFFSET)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(23, 20, 330*TX_SCREEN_OFFSET, 47*TX_SCREEN_OFFSET);  
    [button setBackgroundImage:[UIImage imageNamed:@"confirm-registration-button"] forState:UIControlStateNormal]; 
  //  [button setBackgroundImage:[UIImage imageNamed:@"confirm-registration-button"] forState:UIControlStateHighlighted]; 
    
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [button addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    return footView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

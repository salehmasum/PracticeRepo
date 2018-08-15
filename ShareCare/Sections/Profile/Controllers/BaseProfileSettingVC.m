//
//  BaseProfileSettingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseProfileSettingVC.h"
@interface BaseProfileSettingVC ()

@end

@implementation BaseProfileSettingVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    saveButton.tintColor = COLOR_GRAY;
    self.navigationItem.rightBarButtonItem = saveButton;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    self.profileModel = [[ProfileModel alloc] init];
  //  [self updateUI];
  [self getProfile];
      
    
}

- (void)getProfile{
    __weak typeof(self) weakself = self;
    NSArray *array = @[SHARE_TYPE_FOR(self.roleType)]; 
    [ShareCareHttp GET:API_GET_USERINFO withParaments:array withSuccessBlock:^(id response) { 
        @try{
           // USERDEFAULT_SET(@"token", response[@"token"]);   
          //  USERDEFAULT_SET(@"userName", response[@"userName"]);   
            
            [Util saveUserName:response[@"fullName"] userIcon:response[@"userIcon"]];
             
            weakself.profileModel = [ProfileModel modelWithDictionary:response]; 
            weakself.childrens = [NSMutableArray arrayWithArray:weakself.profileModel.children];
        }@catch(NSException *e){
            
        }@finally{ 
             [weakself updateUI];
        }
        
        
    } withFailureBlock:^(NSString *error) {
        //  [SVProgressHUD showErrorWithStatus:error]; 
    }];
}

- (void)updateUserIcon:(UIImage *)photo{
    
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp upload:API_UPDATE_USER_ICON withParaments:@{} photos:@[photo] 
      uploadProgressBlock:^(float progress) {
          [SVProgressHUD showProgress:progress];
      } withSuccessBlock:^(id response) {
          NSLog(@"%@",response);
          [SVProgressHUD dismiss]; 
          weakSelf.profileModel.userIcon = response;
          
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
      }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)save:(id)sender{
    
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

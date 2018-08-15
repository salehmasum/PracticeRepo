//
//  SProfileSettingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SProfileSettingVC.h"
#import "ChildrensSelectedCell.h"
#import "SKFPreViewNavController.h"
#import "UIViewController+AddressBook.h" 
#import "NewChildrenTableVC.h"
#import "UIViewController+GooglePlace.h"

@interface SProfileSettingVC ()<UITableViewDelegate,UITableViewDataSource,AddChildrenDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFullName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldContact;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmergency;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
 
@property (strong, nonatomic) UIImage *userImage;



@end

@implementation SProfileSettingVC
- (void)viewWillAppear:(BOOL)animated{   
    [super viewWillAppear:animated];
   // [self getProfile];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ChildrensSelectedCell class]) bundle:nil] forCellReuseIdentifier:@"child"]; 
    [self setKeyboardNotificationWith:self.tableView]; 
    
    self.textFieldFullName.text = kUSER_USERNAME;
    NSString *userIcon = kUSER_USERICON;
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                 placeholderImage:kDEFAULT_IMAGE];
    
    
    
    
} 
- (UserRoleType)roleType{
    return UserRoleTypeEvent;
}
- (void)updateUI{
    self.textFieldFullName.text = [self.profileModel.fullName length]==0?kUSER_USERNAME:self.profileModel.fullName;
    self.textFieldContact.text = self.profileModel.contactNumber;
    self.textFieldEmergency.text = self.profileModel.emergencyContact;
    
    if(self.profileModel.address.length==0||
       self.profileModel.addressLat == 0||
       self.profileModel.addressLon == 0){
        
        
//        [self currentAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
//            self.lbAddress.text = address;
//            self.profileModel.address = address;
//            self.profileModel.addressLat = coordinate.latitude;
//            self.profileModel.addressLon = coordinate.longitude;
//        }];
    }else{  
        self.lbAddress.text = [self.profileModel.address componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
    }
    
    self.childrens = [NSMutableArray arrayWithArray:self.profileModel.children];
    
    NSString *userIcon = kUSER_USERICON;
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                 placeholderImage:kDEFAULT_IMAGE];
    
    [self.tableView reloadData];
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender { 
} 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
} 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.childrens.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60*TX_SCREEN_OFFSET;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChildrensSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"child" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ChildrenModel *child = self.childrens[indexPath.row];
    
    [cell.icon setImageWithURL:[NSURL URLWithString:URLStringForPath(child.childIconPath)] 
              placeholderImage:kDEFAULT_HEAD_IMAGE];
    cell.lbName.text = child.fullName;
    return cell;
}
//图片预览
- (IBAction)previewPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.profileModel.userIcon.length) { 
        NSMutableArray *photos = [NSMutableArray arrayWithArray:@[URLStringForPath(self.profileModel.userIcon)]];
        SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:photos index:0];
        
        [imagePickerVc setDidFinishDeletePic:^(NSArray<UIImage *> *photos) {
            self.imgUser.image = kDEFAULT_IMAGE;
            self.userImage = nil;
        }]; 
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
- (IBAction)selectEmergencyContact:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self showAddressBookSelected:^(NSString *name, NSString *phone) {
        NSLog(@"%@,%@",name,phone); 
        weakSelf.textFieldEmergency.text = [NSString stringWithFormat:@"%@,%@",name,phone];
    }];
}
- (IBAction)childrenEdit:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NewChildrenTableVC *childrenVC = [[NewChildrenTableVC alloc] initWithStyle:UITableViewStyleGrouped];
    childrenVC.childrens = [NSMutableArray arrayWithArray:self.profileModel.children];
    childrenVC.delegate = self;
    [self.navigationController pushViewController:childrenVC animated:YES];
}

- (void)reloadChildrens:(NSArray *)childrens{
    self.childrens = [NSMutableArray arrayWithArray:childrens];
    [self.tableView reloadData];
}

- (IBAction)takeOrChoosePhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self showPhotoSourceType:SourceTypeCameraOrPhotoLibrary 
                   alerttitle:@"Upload Profile Photo" 
                        photo:^(UIImage *photo) {
        weakSelf.imgUser.image = photo;
        weakSelf.userImage = photo;
        [weakSelf updateUserIcon:photo];
    }];
    
    
    
    
}
- (IBAction)editAddress:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self GMSAutocompleteAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
        weakSelf.lbAddress.text = [address componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
        
        weakSelf.profileModel.address = address;
        weakSelf.profileModel.addressLon = coordinate.longitude;
        weakSelf.profileModel.addressLat = coordinate.latitude;
    }];
    
}
#pragma mark - request
/*------request--------------------------------------------------------*/
- (BOOL)checkAvilible{
    
    if (self.profileModel.userIcon.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"Please upload profile photo before saving."];return NO;
    }
    
    if (_textFieldContact.text.length == 0 ||
        _lbAddress.text.length == 0) { 
        [SVProgressHUD showErrorWithStatus:@"Please fill in all the fields before saving."];return NO;
    }
  
     
   
    return YES;
}
- (void)save:(id)sender{
    
    
    
    __block typeof(self) weakeSelf = self;
    self.profileModel.fullName = _textFieldFullName.text;
    self.profileModel.contactNumber = _textFieldContact.text;
    self.profileModel.emergencyContact = _textFieldEmergency.text;  
    self.profileModel.shareType = SHARE_TYPE_FOR(self.roleType);
    self.profileModel.children = self.childrens; 
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:[self.profileModel convertToDictionary]]; 
    
#ifdef DEBUG 
    if (self.profileModel.address.length == 0) {
        [parameter setObject:@"Xi'an" forKey:@"address"];
        [parameter setObject:@"34.849372" forKey:@"addressLat"];
        [parameter setObject:@"108.838749" forKey:@"addressLon"];
    }
   
#else 
    if (![self checkAvilible]) return;
#endif 
    
    NSLog(@"%@",parameter);
    
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    [ShareCareHttp POST:API_UPDATE_USERINFO withParaments:parameter 
       withSuccessBlock:^(id response) {
           
           id userInfoDto = response[@"userInfoDto"]; 
           if ([userInfoDto isKindOfClass:[NSArray class]]) {
               NSArray *array = (NSArray *)userInfoDto;
               for (NSDictionary *obj in array) {
                   NSString *key_fullName = [NSString stringWithFormat:@"%@_fullName",obj[@"shareType"]];
                   NSString *key_userIcon = [NSString stringWithFormat:@"%@_userIcon",obj[@"shareType"]];
                   
                   USERDEFAULT_SET(key_fullName, obj[@"fullName"]);
                   USERDEFAULT_SET(key_userIcon, obj[@"userIcon"]);
               }
           }
           NSString * fullName =  userInfoDto[@"fullName"];
           NSString * userIcon =  userInfoDto[@"userIcon"];
           if (fullName.length!=0) { 
               USERDEFAULT_SET(@"userName", userInfoDto[@"fullName"]);
           }
           
           if (userIcon.length!=0) { 
               USERDEFAULT_SET(@"userIcon", userInfoDto[@"userIcon"]);
           }
           
           [Util saveUserName:fullName userIcon:userIcon];
           
           [SVProgressHUD showSuccessWithStatus:@"Save success"];
           [weakeSelf.navigationController popViewControllerAnimated:YES];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
     
}

- (BOOL)checkListtingCanBooking:(NSString *)listId{
    
    
    
    
    
    
    return YES;
}


@end

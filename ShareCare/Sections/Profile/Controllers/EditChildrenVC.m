//
//  EditChildrenVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EditChildrenVC.h"
#import "ZPicker.h"
#import "UIViewController+AddressBook.h" 
#import "SKFPreViewNavController.h"
#import "UIViewController+KeyboardState.h"
#import "ProfileModel.h"
@interface EditChildrenVC ()<UITextFieldDelegate>{ 
    
}
@property (strong, nonatomic) ZPicker *pickerView;
@property (strong, nonatomic) UIImage *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (weak, nonatomic) IBOutlet UILabel *lbAge;
@property (weak, nonatomic) IBOutlet UILabel *lbGender;
@property (weak, nonatomic) IBOutlet UITextField *tfFullName;
@property (weak, nonatomic) IBOutlet UILabel *lbEmergency;
@property (weak, nonatomic) IBOutlet UITextField *tfRelationship;
@end

@implementation EditChildrenVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_child == nil) {
        _child = [[ChildrenModel alloc] init];
    }
    
    NSLog(@"%@",[_child convertToDictionary]);
    
    _tfRelationship.delegate = self;
    self.title = @"Add/Edit Child"; 
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];    
    saveButton.tintColor = COLOR_GRAY;    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    _tfFullName.text = _child.fullName; 
    _lbAge.text = [NSString stringWithFormat:@"Age: %@",_child.age];
    _lbGender.text = [NSString stringWithFormat:@"Gender: %@",_child.gender];
    _lbEmergency.text = [NSString stringWithFormat:@"Emergency Contact: %@",_child.emergencyContactPerson];
    _tfRelationship.text = [NSString stringWithFormat:@"%@",_child.relationship];
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(_child.childIconPath)] 
                 placeholderImage:kDEFAULT_IMAGE];
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil]; 
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [value CGRectValue]; 
    [UIView animateWithDuration:0.2 animations:^{
        self.view.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT/2-150);
    }];
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度 
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT/2);
    }];
} 
- (void)save:(id)sender{ 
   // [self saveChildToService];return;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self checkAvilibity:_child]) { 
        if (_childBlock) {
            _childBlock(_child);
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [self saveChildToService];
        }
    }
}
- (IBAction)textFieldEditingChanged:(UITextField *)textField {
   // self.child.fullName = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder]; 
    self.child.fullName = _tfFullName.text;
    self.child.relationship = _tfRelationship.text;
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.child.fullName = _tfFullName.text;
    self.child.relationship = _tfRelationship.text;
}
- (IBAction)editphotos:(id)sender { 
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __block typeof(self) weakeSelf = self;
//    [self showCanEdit:NO photo:^(UIImage *photo) {
//       
//    }];
    
    [self showPhotoSourceType:SourceTypeCameraOrPhotoLibrary 
                   alerttitle:@"Upload Profile Photo" 
                        photo:^(UIImage *photo) {
                            weakeSelf.imgUser.image = photo;
                            [weakeSelf updateChildrenIcon:photo];
                        }];
    
    
}
- (IBAction)editAge:(id)sender { 
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    NSMutableArray *temp =[NSMutableArray array]; 
    for (NSInteger index=0; index<18; index++) {
        [temp addObject:[NSString stringWithFormat:@"%ld",index+([Util getCurrentYear])-18]];
    }  
    __block typeof(self) weakeSelf = self;
//    [ZPicker showPickerTitle:@"Current Age" dataSource:@[temp] done:^(id object) {
//        weakeSelf.lbAge.text = [NSString stringWithFormat:@"Age:%ldyrs",[Util getCurrentYear]-[object integerValue]];
//        weakeSelf.child.age = [NSString stringWithFormat:@"%ldyrs",[Util getCurrentYear]-[object integerValue]];
//    }];
    
    [ZPicker showDatePickerTitle:@"Date of Birth" done:^(id object, NSDate *one, NSDate *two) {
        NSLog(@"Date of Birth = %@",one);
        weakeSelf.child.birthday = [Util getTimeFromDate:one];
        weakeSelf.lbAge.text = [NSString stringWithFormat:@"Age: %@",weakeSelf.child.age];
    }];
    
} 
- (IBAction)editGender:(id)sender { 
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __block typeof(self) weakeSelf = self;
    [ZPicker showPickerTitle:@"Gender" dataSource:@[@[@"Female",@"Male",@"Not Specified"]] done:^(id object) {
        weakeSelf.lbGender.text = [NSString stringWithFormat:@"Gender: %@",object];
        weakeSelf.child.gender = [NSString stringWithFormat:@"%@",object];
    }];
}
- (IBAction)selectEmergencyContact:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __weak typeof(self) weakSelf = self;
    [self showAddressBookSelected:^(NSString *name, NSString *phone) {
        NSLog(@"%@,%@",name,phone); 
        weakSelf.lbEmergency.text = [NSString stringWithFormat:@"Emergency Contact: %@",name];
        weakSelf.child.emergencyContactPerson = [NSString stringWithFormat:@"%@",name];
        weakSelf.child.emergencyContactPhone = [NSString stringWithFormat:@"%@",phone];
    }];
}
//图片预览
- (IBAction)previewPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (self.child.childIconPath.length) { 
        NSMutableArray *photos = [NSMutableArray arrayWithArray:@[URLStringForPath(self.child.childIconPath)]];
        SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:photos index:0];
         
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
- (void)updateChildrenIcon:(UIImage *)photo{
    
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp upload:API_UPDATE_CHILD_ICON withParaments:@{} photos:@[photo] 
      uploadProgressBlock:^(float progress) {
          [SVProgressHUD showProgress:progress];
      } withSuccessBlock:^(id response) {
          NSLog(@"%@",response);
          [SVProgressHUD dismiss]; 
          weakSelf.child.childIconPath = response;
          
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
      }];
}
- (BOOL)checkAvilibity:(ChildrenModel *)child{
    if (child.childIconPath.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please Take/Choose photos!"];return NO;
    }
    if (child.fullName.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Child FullName!"];return NO;
    }
    if (child.age.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please select age!"];return NO;
    } 
    if (child.gender.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Please select gender!"];return NO;
    } 
    if (child.relationship.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Invalid relationship!"];return NO;
    } 
    return YES;
}


- (void)saveChildToService{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __block typeof(self) weakeSelf = self;  
    NSArray *childrens = @[[_child convertToDictionary]];
    
    NSDictionary *dic = @{@"childrenInfoList":childrens,
                          @"shareType":SHARE_TYPE_EVENT
                          };
    
    NSLog(@"%@",dic);//return;
    
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    [ShareCareHttp POST:API_UPDATE_CHILDINFO withParaments:dic 
       withSuccessBlock:^(id response) {
           weakeSelf.childBlock = nil;
           [SVProgressHUD showSuccessWithStatus:@"Save success"];
           [weakeSelf.navigationController popViewControllerAnimated:YES];
       } withFailureBlock:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
       }];
    
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

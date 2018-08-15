//
//  NewChildrenTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NewChildrenTableVC.h"
#import "NewChildrenCell.h"
#import "EditChildrenVC.h"
#import "ZPicker.h"
#import "UIViewController+AddressBook.h" 

@interface NewChildrenTableVC (){ 
}

@property (strong, nonatomic) IBOutlet UIView *headView;
@end

@implementation NewChildrenTableVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];  
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
//    if (_childrens.count) {
//        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];    
//        saveButton.tintColor = COLOR_GRAY;    
//        self.navigationItem.rightBarButtonItem = saveButton;
//    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (_delegate) {
        [_delegate reloadChildrens:_childrens];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  //  _childrens = [NSMutableArray array];
    if (!_childrens) {
        _childrens = [NSMutableArray array];
    }
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewChildrenCell class]) bundle:nil] forCellReuseIdentifier:@"children"];
    self.title = @"Edit Personal Profile"; 
    
//    if (_childrens.count == 0) {
//        [self addChildren:nil];
//    }
    [self getProfile];
} 

- (void)getProfile{
 //   [SVProgressHUD showWithStatus:TEXT_LOADING];
    __weak typeof(self) weakself = self;
    NSArray *array = @[SHARE_TYPE_FOR(UserRoleTypeEvent)]; 
    [ShareCareHttp GET:API_GET_USERINFO withParaments:array withSuccessBlock:^(id response) { 
        @try{ 
            
            [Util saveUserName:response[@"fullName"] userIcon:response[@"userIcon"]];
            
            ProfileModel *profileModel = [ProfileModel modelWithDictionary:response]; 
            weakself.childrens = [NSMutableArray arrayWithArray:profileModel.children];
            [weakself.tableView reloadData];
             
            if (weakself.childrens.count == 0) {
                 [weakself addChildren:nil];
            }
            
        }@catch(NSException *e){ 
        }@finally{  
        }
        
        
    } withFailureBlock:^(NSString *error) {
        //  [SVProgressHUD showErrorWithStatus:error]; 
    }];
}

- (IBAction)addChildren:(id)sender {
    __block typeof(self) weakeSelf = self;
    EditChildrenVC *editChildrenVC = [[EditChildrenVC alloc] init];
    editChildrenVC.childBlock = ^(ChildrenModel *child) {
        child.childStatus = @"0";
        [weakeSelf.childrens addObject:child];
        [weakeSelf.tableView reloadData];
         
        [weakeSelf save:nil];
    };
    [self.navigationController pushViewController:editChildrenVC animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _childrens.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190*TX_SCREEN_OFFSET;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 128*TX_SCREEN_OFFSET;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewChildrenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"children" forIndexPath:indexPath];
    
    // Configure the cell...
    
    __block typeof(self) weakeSelf = self;
    cell.editNameBlock = ^{
        [weakeSelf editNameAtIndex:indexPath.row];
    };
    cell.editAgeBlock = ^{
        [weakeSelf editAgeAtIndex:indexPath.row];
    };
    cell.editGenderBlock = ^{
        [weakeSelf editGenderAtIndex:indexPath.row];
    };
    cell.editPhoneBlock = ^{
        [weakeSelf editEmergencyContact:indexPath.row];
    };
    ChildrenModel *child = self.childrens[indexPath.row];
    cell.lbAge.text = [NSString stringWithFormat:@"Age: %@",child.age];
    cell.lbGender.text = [NSString stringWithFormat:@"Gender: %@",child.gender];
    cell.lbPhone.text = [NSString stringWithFormat:@"Emergency Contact: %@",child.emergencyContactPerson];
    cell.lbName.text = child.fullName;
    cell.lbRelationship.text = [NSString stringWithFormat:@"Relationship: %@",child.relationship];
    [cell.icon setImageWithURL:[NSURL URLWithString:URLStringForPath(child.childIconPath)] 
                 placeholderImage:kDEFAULT_HEAD_IMAGE];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";//默认文字为 Delete
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self removePayMethodAtIndex:indexPath.row];
    }
    
}
- (void)removePayMethodAtIndex:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    ChildrenModel *child = self.childrens[index];
    [ShareCareHttp GET:@"/v1/user/api/accounts/delete/children/" 
         withParaments:@[child.childId]
      withSuccessBlock:^(id response) {
          [SVProgressHUD showSuccessWithStatus:@"Deleted Successed!"];
          
          [weakSelf.childrens removeObject:child];
          [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        //  [weakSelf updateUI];
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
      }];
}




- (void)editNameAtIndex:(NSInteger)index{
    __block typeof(self) weakeSelf = self;
    EditChildrenVC *editChildrenVC = [[EditChildrenVC alloc] init];
    editChildrenVC.child = [ChildrenModel modelWithDictionary:[_childrens[index] convertToDictionary]];
    editChildrenVC.childBlock = ^(ChildrenModel *child) {
        [weakeSelf.childrens replaceObjectAtIndex:index withObject:child];
        [weakeSelf.tableView reloadData];
        [weakeSelf save:nil];
    };
    [self.navigationController pushViewController:editChildrenVC animated:YES];
}

- (void)editAgeAtIndex:(NSInteger)index{
    NSMutableArray *temp =[NSMutableArray array]; 
    for (NSInteger index=0; index<18; index++) {
        [temp addObject:[NSString stringWithFormat:@"%ld",index+([Util getCurrentYear])-18]];
    }  
    __block typeof(self) weakeSelf = self;
    __block typeof(NewChildrenCell) *cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]]; 
//    [ZPicker showPickerTitle:@"Current Age" dataSource:@[temp] done:^(id object) {
//        cell.lbAge.text = [NSString stringWithFormat:@"Age:%ldyrs",[Util getCurrentYear]-[object integerValue]];
//        
//        ChildrenModel *child = weakeSelf.childrens[index];
//        child.age = [NSString stringWithFormat:@"%ldyrs",[Util getCurrentYear]-[object integerValue]];;
//    }];
    
    [ZPicker showDatePickerTitle:@"Date of Birth" done:^(id object, NSDate *one, NSDate *two) {
        NSLog(@"Date of Birth = %@",one);
        
        ChildrenModel *child = weakeSelf.childrens[index]; 
        child.birthday = [Util getTimeFromDate:one];
        
        cell.lbAge.text = [NSString stringWithFormat:@"Age: %@",child.age];
    }];
    
}
- (void)editGenderAtIndex:(NSInteger)index{
    __block typeof(self) weakeSelf = self;
    __block typeof(NewChildrenCell) *cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]]; 
    [ZPicker showPickerTitle:@"Gender" dataSource:@[@[@"Female",@"Male",@"Not Specified"]] done:^(id object) {
        cell.lbGender.text = [NSString stringWithFormat:@"Gender: %@",object];
        ChildrenModel *child = weakeSelf.childrens[index];
        child.gender = object;
        
    }];
}
- (IBAction)editEmergencyContact:(NSInteger)index { 
    __block typeof(NewChildrenCell) *cell =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    __weak typeof(self) weakSelf = self;
    [self showAddressBookSelected:^(NSString *name, NSString *phone) {
        NSLog(@"%@,%@",name,phone); 
        cell.lbPhone.text = [NSString stringWithFormat:@"Emergency Contact: %@",name];
        ChildrenModel *child = weakSelf.childrens[index];
        child.emergencyContactPhone = phone;
        child.emergencyContactPerson = name;
    }];
}
- (void)save:(id)sender{
    __block typeof(self) weakeSelf = self; 
    
    ProfileModel *profile = [[ProfileModel alloc] init];
    profile.children = self.childrens;
    NSDictionary *parameter = [profile convertToDictionary];
    
    NSDictionary *dic = @{@"childrenInfoList":parameter[@"children"],
                          @"shareType":SHARE_TYPE_EVENT
                          };
    
    NSLog(@"%@",parameter);//return;
    
    if(sender)[SVProgressHUD showWithStatus:TEXT_LOADING]; 
    [ShareCareHttp POST:API_UPDATE_CHILDINFO withParaments:dic 
       withSuccessBlock:^(id response) {
           if(sender)[SVProgressHUD showSuccessWithStatus:@"Save success"];
           if(sender)[weakeSelf.navigationController popViewControllerAnimated:YES];
       } withFailureBlock:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
           
           UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];    
           saveButton.tintColor = COLOR_GRAY;    
           weakeSelf.navigationItem.rightBarButtonItem = saveButton;
           
           
       }];
    
}

@end

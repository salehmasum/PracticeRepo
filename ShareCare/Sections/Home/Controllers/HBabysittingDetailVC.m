//
//  HBabysittingDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HBabysittingDetailVC.h"
#import "AgesCell.h"
#import "BabysittingCheckAvailabilityVC.h"
#import "BProfileSettingVC.h"
#import "SProfileSettingVC.h"
@interface HBabysittingDetailVC (){
    BabysittingModel *_babysitting;
}

@end

@implementation HBabysittingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.item)_babysitting = (BabysittingModel *)self.item;
    [self.favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"inspect-like-enabled"]:[UIImage imageNamed:@"inspect-like-disabled"]];
    
    [self.checkAvailabilityView configPrice:[NSString stringWithFormat:@"$%@/hr",_babysitting.chargePerHour] 
             location:_babysitting.headLine
                                   careType:1]; 
    self.checkAvailabilityView.lbReviews.text = [NSString stringWithFormat:@"%@ Reviews",_babysitting.reviewsCount];
    self.checkAvailabilityView.starView.scorePercent = [_babysitting.totalStarRating floatValue];  
    
    self.checkAvailabilityView.btnCheckAvailable.enabled = ((BabysittingModel *)self.item).babysittingStatus.integerValue==4;
    
    if (self.idValue) {
     //   [self requestDetail];
    }
}

- (void)requestDetail{
    [ShareCareHttp GET:API_SHARECARE_DETAIL withParaments:@[self.idValue] withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            _babysitting = [BabysittingModel modelWithDictionary:response];
            [self.tableView reloadData];
        }
    } withFailureBlock:^(NSString *error) {
        
    }];
}
- (void)changFavoriteStatus:(id)sender{
    
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"fType":[NSString stringWithFormat:@"%i",self.roleType],
                          @"fTypeId":_babysitting.idValue,
                          @"status":[NSString stringWithFormat:@"%d",!_babysitting.isFavorite] 
                          };
    NSLog(@"token=%@,dic=%@",kUSER_TOKEN,dic);
    [ShareCareHttp POST:API_SHARECARE_FAVORITE_ADD_OR_REMOVE withParaments:dic withSuccessBlock:^(id response) {
        _babysitting.isFavorite = !_babysitting.isFavorite;
        [weakSelf.favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"inspect-like-enabled"]:[UIImage imageNamed:@"inspect-like-disabled"]];
        if (weakSelf.favoriteBlock) weakSelf.favoriteBlock(_babysitting,_babysitting.isFavorite);
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ Favourites",_babysitting.isFavorite?@"Added to":@"Removed from"]];
       // SET_AUTOM_REFRESH_FAVORITE(YES);
        SET_AUTOM_REFRESH_FAVORITE([dic[@"fType"] intValue], YES);
        SET_AUTOM_REFRESH_FAVORITE(Faveritor_all, YES);
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)checkAvailabilityClick:(id)sender{
    
    if (_babysitting.accountId.integerValue == kUSER_ID.integerValue) { 
        UIAlertController *alertController = [UIAlertController 
                                              alertControllerWithTitle:@"Can’t make a booking, because it’s created by yourself!" 
                                              message:nil 
                                              preferredStyle:UIAlertControllerStyleAlert]; 
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]; 
        
        
        [alertController addAction:cancelAction]; 
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
    
    
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSArray *array = @[SHARE_TYPE_FOR(UserRoleTypeEvent)]; 
    [ShareCareHttp GET:API_GET_USERINFO withParaments:array withSuccessBlock:^(id response) { 
        
        NSString *address = response[@"address"]; 
        NSString *addressLat = response[@"addressLat"]; 
        NSString *addressLon = response[@"addressLon"]; 
        if (address.length && addressLat.doubleValue!=0 &&addressLon.doubleValue!=0) {
            BabysittingCheckAvailabilityVC *detail = [[BabysittingCheckAvailabilityVC alloc] init];
            detail.item = _babysitting;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            [self showAlertToSettingAddress];
        }
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    }
}



- (void)showAlertToSettingAddress{
    
    
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"You must set your address first." 
                                          message:nil 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sharecareAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf settings];
    }];
    
   
    [alertController addAction:cancelAction];
    [alertController addAction:sharecareAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)settings{
    SProfileSettingVC *settingVC = [[SProfileSettingVC alloc] init];
    settingVC.title = @"Edit Personal Profile"; 
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 0;
            break;
        case 2:
            return 0;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        case 6:
            return self.reviewDtoList.count>2?2:self.reviewDtoList.count;
            break; 
        case 7:
            return self.reviewDtoList.count>=2;
            break;
        default:
            break;
    } 
    
    return 0;
} 

- (AgeRangeModel *)ageRangeModel{
    return _babysitting.babyAgeRangeModel;
}
- (CredentialsModel*)credentialsModel{
    return _babysitting.credentialsModel;
}
- (NSString *)thumbnail{
    return _babysitting.thumbnail;
}
- (NSString *)headline{
    return _babysitting.headLine;
}
- (NSString *)typeString{
    return [NSString stringWithFormat:@"Hosted by %@",_babysitting.userName];
} 
- (NSArray *)photos{
    return _babysitting.photosPath;
}
- (NSString *)about{
    return _babysitting.aboutMe;
}
- (NSString *)userIcon{
    return _babysitting.userIcon;
}
- (NSString *)userName{
    return _babysitting.userName;
}
- (NSString *)accountId{
    return _babysitting.accountId;
}
- (UserRoleType)roleType{
    return UserRoleTypeBabySitting;
}
- (BOOL)isFavorite{
    return _babysitting.isFavorite;
}
- (CGFloat)totalStarRating{
    return _babysitting.totalStarRating.floatValue;
}
- (NSMutableAttributedString *)aboutAttributedString{
    NSString *str = [NSString stringWithFormat:@"About this Babysitter • %@\n%@\n",_babysitting.userName,_babysitting.aboutMe];
    
     
    NSString *about = [NSString stringWithFormat:@"About this Babysitter • %@",_babysitting.userName]; 
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str]; 
    NSRange range = [str rangeOfString:about];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_FONT(16)
                    range:range];  
    
    return attrStr;
}


- (void)setReviewDtoList:(NSArray *)reviewDtoList{
    _babysitting.reviewDtoList = reviewDtoList;
}
- (NSArray *)reviewDtoList{
    return _babysitting.reviewDtoList;
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

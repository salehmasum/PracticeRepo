//
//  HShareCareDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HShareCareDetailVC.h"

@interface HShareCareDetailVC (){
    ShareCareModel *_shareCare;
}

@end

@implementation HShareCareDetailVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.item) {
        _shareCare = (ShareCareModel *)self.item;
    }
    [self.favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"inspect-like-enabled"]:[UIImage imageNamed:@"inspect-like-disabled"]];
    
    [self.checkAvailabilityView configPrice:[NSString stringWithFormat:@"$%@/day",_shareCare.moneyPerDay] 
                                   location:_shareCare.address
                                   careType:0];
    self.checkAvailabilityView.lbReviews.text = [NSString stringWithFormat:@"%@ Reviews",_shareCare.reviewsCount];
    self.checkAvailabilityView.starView.scorePercent = [_shareCare.totalStarRating floatValue];
    
    self.childrens = [NSMutableArray array]; 
    self.checkAvailabilityView.btnCheckAvailable.enabled = NO;
    if (self.idValue) {
      //  [self requestDetail];
    }
    
    [self requestBookingChild];
}

- (void)requestDetail{
    [ShareCareHttp GET:API_SHARECARE_DETAIL withParaments:@[self.idValue] withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            _shareCare = [ShareCareModel modelWithDictionary:response];
            [self.tableView reloadData];
        }
    } withFailureBlock:^(NSString *error) {
        
    }];
}


- (void)changFavoriteStatus:(id)sender{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"fType":[NSString stringWithFormat:@"%ld",self.roleType],
                          @"fTypeId":_shareCare.idValue,
                          @"status":[NSString stringWithFormat:@"%d",!_shareCare.isFavorite]
                          
                          };
    NSLog(@"token=%@,dic=%@",kUSER_TOKEN,dic);
    [ShareCareHttp POST:API_SHARECARE_FAVORITE_ADD_OR_REMOVE withParaments:dic withSuccessBlock:^(id response) {
        _shareCare.isFavorite = !_shareCare.isFavorite;
        [weakSelf.favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"inspect-like-enabled"]:[UIImage imageNamed:@"inspect-like-disabled"]];
        
        if (weakSelf.favoriteBlock) weakSelf.favoriteBlock(_shareCare,_shareCare.isFavorite);
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ Favourites",_shareCare.isFavorite?@"Added to":@"Removed from"]];
       // SET_AUTOM_REFRESH_FAVORITE(YES);
        SET_AUTOM_REFRESH_FAVORITE([dic[@"fType"] intValue], YES);
        SET_AUTOM_REFRESH_FAVORITE(Faveritor_all, YES);
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
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
- (NSString *)thumbnail{
    return _shareCare.thumbnail;
}
- (NSString *)headline{
    return _shareCare.headline;
}
- (NSString *)typeString{
    return [NSString stringWithFormat:@"EleCare • %@",_shareCare.userName];
}
- (NSString *)address{
    return _shareCare.address;
}
- (NSString *)dateAndTime{
    return _shareCare.availableTimeEN;
}
- (NSArray *)photos{
    return _shareCare.photosPath;
}
- (NSString *)about{
    return _shareCare.shareCareContent;
}
- (NSString *)userIcon{
    return _shareCare.userIcon;
}
- (NSString *)userName{
    return _shareCare.userName;
}
- (NSString *)accountId{
    return _shareCare.accountId;
}
- (UserRoleType)roleType{
    return UserRoleTypeShareCare;
}

- (CGFloat)totalStarRating{
    return _shareCare.totalStarRating.floatValue;
}
- (BOOL)isFavorite{
    return _shareCare.isFavorite;
}

- (void)setReviewDtoList:(NSArray *)reviewDtoList{
    _shareCare.reviewDtoList = reviewDtoList;
}

- (NSArray *)reviewDtoList{
    return _shareCare.reviewDtoList;
}
- (AgeRangeModel *)ageRangeModel{
    return _shareCare.babyAgeRangeModel;
}
- (CredentialsModel*)credentialsModel{
    return _shareCare.credentialsModel;
}
- (NSMutableAttributedString *)aboutAttributedString{
    NSString *str = [NSString stringWithFormat:@"About this EleCare\n%@\n\n",_shareCare.shareCareContent];
    
    
    NSString *about = @"About this EleCare"; 
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    
    
    NSRange range = [str rangeOfString:about];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_FONT(16)
                    range:range];  
    
    return attrStr;
}
- (BOOL)checkAvailableTime{
    NSString *availableTime = ((ShareCareModel *)self.item).availableTime; 
    NSArray *times = [availableTime componentsSeparatedByString:@","];
    
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *today = [dateFormatter stringFromDate:[NSDate date]];
    for (NSString *time in times) {
        if ([time compare:today] == NSOrderedDescending) {
            return YES;
        }
    }
    return NO;
}
- (void)requestBookingChild{
    
    self.checkAvailabilityView.btnCheckAvailable.enabled = ((ShareCareModel *)self.item).shareCareStatus.integerValue==4;
    
  //  [SVProgressHUD showWithStatus:TEXT_LOADING];
  //  __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_APPOINTED_CHILD 
         withParaments:@[@"0",_shareCare.idValue] 
      withSuccessBlock:^(id response) {
          _shareCare.joinChildrens = response;
          [SVProgressHUD dismiss];
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
          self.checkAvailabilityView.btnCheckAvailable.enabled = NO;
      }];
}
 
- (void)checkAvailabilityClick:(id)sender{
    if (_shareCare.accountId.integerValue == kUSER_ID.integerValue) { 
        UIAlertController *alertController = [UIAlertController 
                                              alertControllerWithTitle:@"Can’t make a booking, because it’s created by yourself!" 
                                              message:nil 
                                              preferredStyle:UIAlertControllerStyleAlert]; 
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]; 
        
        
        [alertController addAction:cancelAction]; 
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        CheckAvailabilityVC *detail = [[CheckAvailabilityVC alloc] init];
        detail.availableTime = _shareCare.availableTime;
        detail.item = _shareCare;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
   
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

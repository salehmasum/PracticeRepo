//
//  HEventDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HEventDetailVC.h"

@interface HEventDetailVC (){
    EventModel *_event;
}

@end

@implementation HEventDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.item)_event = (EventModel *)self.item;
    [self.favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"inspect-like-enabled"]:[UIImage imageNamed:@"inspect-like-disabled"]];
    
    [self.checkAvailabilityView configPrice:_event.listingHeadline 
                                   location:_event.ageRange
                                   careType:2];
    self.checkAvailabilityView.lbdesc.text = self.dateAndTime;
    self.checkAvailabilityView.starView.hidden = YES;
    self.checkAvailabilityView.lbReviews.hidden = YES;
    self.checkAvailabilityView.lbReviews.text = [NSString stringWithFormat:@"%@ Reviews",_event.reviewsCount];
    self.checkAvailabilityView.starView.scorePercent = [_event.totalStarRating floatValue];
     
    [self.checkAvailabilityView.btnCheckAvailable setImage:[UIImage imageNamed:@"join-group-button"] 
                                                  forState:UIControlStateNormal];
    [self.checkAvailabilityView.btnCheckAvailable setImage:[UIImage imageNamed:@"join-group-button-disabled"] 
                                                  forState:UIControlStateDisabled]; 
    
    
    self.booking = [[BookingModel alloc] init];
    self.booking.careType = @"2";
    self.booking.careId = ((EventModel *)self.item).idValue;
    self.booking.startDate = ((EventModel *)self.item).startDate;
    self.booking.endDate = ((EventModel *)self.item).endDate;
    self.booking.userName = ((EventModel *)self.item).userName;
    self.booking.firstPic = ((EventModel *)self.item).thumbnail;
    self.booking.userIcon = ((EventModel *)self.item).userIcon;
    self.booking.stayDays = @"1";
    self.booking.accountId = ((EventModel *)self.item).accountId;
    
    self.booking.unitPrice = ((EventModel *)self.item).child;
    
//    self.booking.times = @[@{@"day":[((EventModel *)self.item).startDateStr componentsSeparatedByString:@" • "][0],
//                             @"time":[NSString stringWithFormat:@"%@ - %@",[((EventModel *)self.item).startDateStr componentsSeparatedByString:@" • "][1],[((EventModel *)self.item).endDateStr componentsSeparatedByString:@" • "][1]]
//                             }];
    
    
    NSString *timePeriod =[NSString stringWithFormat:@"%@ - %@",self.booking.startDate,self.booking.endDate];
                             
    
    self.booking.times = @[@{@"day":((EventModel *)self.item).startDateStr,
                             @"time":((EventModel *)self.item).endDateStr,
                             @"timePeriod":timePeriod
                             }];
    
    [self requestBookedChilds];
    if (self.idValue) {
      //  [self requestDetail];
    }
}
- (void)requestDetail{
    [ShareCareHttp GET:API_SHARECARE_DETAIL withParaments:@[self.idValue] withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            _event = [EventModel modelWithDictionary:response];
            [self.tableView reloadData];
        }
    } withFailureBlock:^(NSString *error) {
        
    }];
}
- (void)requestBookedChilds{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_APPOINTED_CHILD 
         withParaments:@[@"2",_event.idValue] 
      withSuccessBlock:^(id response) {
          NSArray *responseArr = (NSArray *)response;
          _event.remainingPlace = [NSString stringWithFormat:@"%lu",_event.maximumAttendees.integerValue-responseArr.count];
          weakSelf.booking.remainingPlace = _event.maximumAttendees.integerValue-responseArr.count;
          [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
          [weakSelf resetCheckAvailabilityStaus];
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
          self.checkAvailabilityView.btnCheckAvailable.enabled = NO;
      }];
}

- (void)resetCheckAvailabilityStaus{
    
    NSString *startDate = _event.startDate;
    if ([startDate containsString:@"T"]) {
        startDate = [startDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        NSDateFormatter *dateFormatter = [Util dateFormatter];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [dateFormatter dateFromString:startDate];
        
        NSComparisonResult result = [date compare:[NSDate date]];
        if (result==NSOrderedDescending && 
            _event.remainingPlace.integerValue>0 &&
            ((EventModel *)self.item).eventStatus.integerValue==4) {
           
            
            self.checkAvailabilityView.btnCheckAvailable.enabled = YES;
        }
    }
     
}

- (void)changFavoriteStatus:(id)sender{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"fType":[NSString stringWithFormat:@"%ld",self.roleType],
                          @"fTypeId":_event.idValue,
                          @"status":[NSString stringWithFormat:@"%d",!_event.isFavorite] 
                          };
    NSLog(@"token=%@,dic=%@",kUSER_TOKEN,dic);
    [ShareCareHttp POST:API_SHARECARE_FAVORITE_ADD_OR_REMOVE withParaments:dic withSuccessBlock:^(id response) {
        _event.isFavorite = !_event.isFavorite;
        [weakSelf.favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"inspect-like-enabled"]:[UIImage imageNamed:@"inspect-like-disabled"]];
        if (weakSelf.favoriteBlock) weakSelf.favoriteBlock(_event,_event.isFavorite);
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ Favourites",_event.isFavorite?@"Added to":@"Removed from"]];
    //    SET_AUTOM_REFRESH_FAVORITE(YES);
        SET_AUTOM_REFRESH_FAVORITE([dic[@"fType"] intValue], YES);
        SET_AUTOM_REFRESH_FAVORITE(Faveritor_all, YES);
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)checkAvailabilityClick:(id)sender{
    if (_event.accountId.integerValue == kUSER_ID.integerValue) { 
        UIAlertController *alertController = [UIAlertController 
                                              alertControllerWithTitle:@"Can’t make a booking, because it’s created by yourself!" 
                                              message:nil 
                                              preferredStyle:UIAlertControllerStyleAlert]; 
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]; 
        
        
        [alertController addAction:cancelAction]; 
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        EventWhosComingVC *detail = [[EventWhosComingVC alloc] initWithNibName:@"WhosComingVC" bundle:nil];
        detail.item = self.item;
        detail.booking = _booking;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
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
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 0;
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
- (NSString *)headline{
    return _event.listingHeadline;
}
- (NSString *)typeString{
    return _event.whereToMeet;
}
- (NSString *)address{
    return [NSString stringWithFormat:@"Hosted by %@",_event.userName];
}
- (NSString *)dateAndTime{
    if ([_event.startDateStr containsString:@" • "] && [_event.endDateStr containsString:@" • "] ) {
        NSString *endStr = [_event.endDateStr componentsSeparatedByString:@" • "][1]; 
        return [NSString stringWithFormat:@"%@-%@",_event.startDateStr,endStr];
    }
     
    return [NSString stringWithFormat:@"%@-%@",_event.startDateStr,_event.endDateStr];
}
- (NSString *)thumbnail{
    return _event.thumbnail;
}
- (NSArray *)photos{
    return _event.imagePath;
}
- (NSString *)about{ 
    return _event.eventDescription;
}
- (NSString *)userIcon{
    return _event.userIcon;
}
- (NSString *)userName{
    return _event.userName;
}
- (NSString *)accountId{
    return _event.accountId;
}
- (UserRoleType)roleType{
    return UserRoleTypeEvent;
}
- (BOOL)isFavorite{
    return _event.isFavorite;
}
- (CGFloat)totalStarRating{
    return _event.totalStarRating.floatValue;
}
- (NSMutableAttributedString *)aboutAttributedString{
    NSString *str = [NSString stringWithFormat:@"Address\n%@\n\nAbout this Event • %@\n%@\n\nWhere to Meet\n%@\n\n",_event.address,_event.listingHeadline,_event.eventDescription,_event.whereToMeet];
    
    
    NSString *address = @"Address";
    NSString *about = [NSString stringWithFormat:@"About this Event • %@",_event.listingHeadline];
    NSString *where = @"Where to Meet";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    
    
    NSRange range = [str rangeOfString:address];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_FONT(16)
                    range:range]; 
    
    range = [str rangeOfString:about];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_FONT(16)
                    range:range]; 
    
    range = [str rangeOfString:where];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_FONT(16)
                    range:range]; 
     
    return attrStr;
}


- (void)setReviewDtoList:(NSArray *)reviewDtoList{
    _event.reviewDtoList = reviewDtoList;
}
- (NSArray *)reviewDtoList{
    return _event.reviewDtoList;
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

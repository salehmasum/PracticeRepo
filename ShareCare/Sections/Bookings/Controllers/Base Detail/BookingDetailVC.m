//
//  BookingDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingDetailVC.h"
#import "WhosComingVC.h"
#import "DeclineBookingDetailVC.h"
#import "ChatViewController.h"
@interface BookingDetailVC ()<DeclineBookingDelegate>

@end

@implementation BookingDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //  self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"booking"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WhosComingCell class]) bundle:nil]
         forCellReuseIdentifier:@"WhosComingCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookingAddressCell class]) bundle:nil]
         forCellReuseIdentifier:@"BookingAddressCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookingCancelCell class]) bundle:nil]
         forCellReuseIdentifier:@"BookingCancelCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BookingAmountCell" bundle:nil]
         forCellReuseIdentifier:@"BookingAmountCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookingMessageCell class]) bundle:nil]
         forCellReuseIdentifier:@"BookingMessageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EventCancelCell class]) bundle:nil]
         forCellReuseIdentifier:@"EventCancelCell"];
   // 
    
    [self currentAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
        
    }];
    
    self.headerView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, 320*TX_SCREEN_OFFSET);
    
    [_headerView addSubview:self.infinitePageView];
    [_headerView addSubview:self.userHeaderImageView];
    
    //  [self setKeyboardNotificationWith:self.tableView];
    
    self.infinitePageView.placeholderImage = kDEFAULT_IMAGE;
    //   self.infinitePageView.delegate = self; 
    
     
    
    if (_bookingId) {
        [self requestBookingDetail];
    }else{
        [self reloadData];
    }
    
}

//获取已参加的小孩
- (void)requestBookingChild:(NSString *)listId careType:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_APPOINTED_CHILD 
         withParaments:@[type,listId] 
      withSuccessBlock:^(id response) {
          
          
          if ([response isKindOfClass:[NSArray class]]) {
              NSMutableArray *childrens = [NSMutableArray arrayWithArray:response];
              NSArray *array = (NSArray *)response;

              for (NSInteger index=0; index<weakSelf.booking.whoIsComings.count; index++) {
                  NSDictionary *child = weakSelf.booking.whoIsComings[index];
                  if ([childrens containsObject:child]) {
                      NSMutableDictionary *mutabChild = [NSMutableDictionary dictionaryWithDictionary:child];
                      [mutabChild setObject:@1 forKey:@"isMyChild"];
                      [childrens replaceObjectAtIndex:index withObject:mutabChild];
                  }
              }
              weakSelf.booking.whoIsComings = childrens;
              
          } 
          [weakSelf.tableView reloadData];
      } withFailureBlock:^(NSString *error) {
          
      }];
}
- (void)reloadData{
     
    self.booking.bookingId = self.bookingId;
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self updateUI];
    NSMutableArray *imgs = [NSMutableArray array];
    for (id path in _booking.shareIcon) {
        [imgs addObject:URLStringForPath(path)];
    }
    
    self.infinitePageView.imagesArray = imgs;
    _lbCareType.text = [NSString stringWithFormat:@"%@%@",_booking.careType.integerValue==0?@"EleCare":(_booking.careType.integerValue==1?@"Babysitting":@"Events"),@""];// • 
    _lbUserName.text = [NSString stringWithFormat:@"Hosted by %@",_booking.pubUserName];
    [self.userHeaderImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.pubUserIcon)] 
                             placeholderImage:kDEFAULT_HEAD_IMAGE];
    
  //  if (_booking.whoIsComings.count) {
        NSString *timePeriod = _booking.whoIsComings.firstObject[@"timePeriod"];
        if ([timePeriod containsString:@"T"]) {
            _booking.times = [timePeriod componentsSeparatedByString:@"|"];
        }else{
            _booking.times = @[[NSString stringWithFormat:@"%@ - %@",_booking.startDate,_booking.endDate]];
        }
 //   }
    [self.tableView reloadData];
}


- (BHInfiniteScrollView *)infinitePageView{
    if (_infinitePageView == nil) {
        _infinitePageView = [[BHInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 60*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, 188*TX_SCREEN_OFFSET)];
    }
    return _infinitePageView;
}
- (UIImageView *)userHeaderImageView{
    if (!_userHeaderImageView) {
        _userHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TX_SCREEN_WIDTH-76*TX_SCREEN_OFFSET-20, ((60+188)*TX_SCREEN_OFFSET)-38*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET)];
        _userHeaderImageView.layer.masksToBounds = YES;
        _userHeaderImageView.layer.cornerRadius = CGRectGetWidth(self.userHeaderImageView.frame)/2.0;
        _userHeaderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _userHeaderImageView.layer.borderWidth = 2;
        _userHeaderImageView.clipsToBounds = YES;
        _userHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userHeaderImageView;
}

- (UIColor *)titleColor{
    switch (_bookingState) {
        case BookingStatePENDING:
        case BookingStateINREVIEW:
            return TX_RGB(255, 216, 0);
            break;
        case BookingStateCONFIRMED:
            return TX_RGB(0, 149, 17);
            break;
        case BookingStateDECLINED:
        case BookingStateCANCEL:
        case BookingStateTransactionFailed:
            return TX_RGB(255, 0, 0);
            break;
        case BookingStateEXPIRED:
            return TX_RGB(62, 62, 62);
            break;
        case BookingStateCOMPLETED:
            return TX_RGB(136, 136, 136);
            break;
        case BookingStateRUNNING:
            return TX_RGB(102, 216, 137);
           // return TX_RGB(0, 149, 17);
            break; 
        case BookingStateCURRENTLY_NOT_RUNNING:
            return TX_RGB(95, 95, 95);
            break;
            
        default:
            return TX_RGB(255, 216, 0);
            break;
    }
}

- (void)requestBookingDetail{
   
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_DETAIL withParaments:@[_bookingId] withSuccessBlock:^(id response) {
        
        weakSelf.booking = [BookingModel modelWithDictionary:response]; 
        
      //  [weakSelf requestBookingChild:weakSelf.booking.typeId careType:weakSelf.booking.careType];
        [weakSelf reloadData];
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
/*
 header:图片、发布者信息
 section=0:时间列表
 section=1:地址列表
 section=2:text:Who's Coming?
 section=3:参加的小孩
 section=4:支付信息（Amount、Booking Code）
 section=5:与发布者联系（Message）
 section=6:取消booking操作
 section=7:取消Event(免费)操作
 footer:Customer support
 */


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _booking?8:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SectionTypeTIMES:
            return _booking.times.count;
            break;
        case SectionTypeADDRESS:
            if (_booking.careType.integerValue == 2) {
                return 2;
            }
            return 1;
            break;
        case SectionTypeWHOSCOIMG:
            return 1;
            break;
        case SectionTypeCHILDRENS:
            return _booking.whoIsComings.count;
            break;
        case SectionTypePAYINFO:
            return _booking.totalPrice.floatValue>0;
            break;
        case SectionTypeMESSAGE:
            return 1;//_booking.totalPrice.floatValue>0;
            break;
        case SectionTypeCANCELBOOKING:
            return (_booking.careType.integerValue != 2 && (_booking.bookingStatus.integerValue==BookingStatePENDING ||_booking.bookingStatus.integerValue==BookingStateCONFIRMED));
            break;
        case SectionTypeCANCELEVENT:
            return (_booking.careType.integerValue == 2 && (_booking.bookingStatus.integerValue==BookingStatePENDING ||_booking.bookingStatus.integerValue==BookingStateCONFIRMED));
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case SectionTypeTIMES:
            return 44;
            break;
        case SectionTypeADDRESS:
            return 87;
            break;
        case SectionTypeWHOSCOIMG:
            return 55;
            break;
        case SectionTypeCHILDRENS:
            return 84*TX_SCREEN_OFFSET;
            break;
        case SectionTypePAYINFO:
            return 173;
            break;
        case SectionTypeMESSAGE:
            return 145;
            break;
        case SectionTypeCANCELBOOKING:
            return 139;
            break;
        case SectionTypeCANCELEVENT:
            return 98;
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf= self;
    if (indexPath.section==SectionTypeTIMES) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"booking" forIndexPath:indexPath];
        // Configure the cell...
        cell.textLabel.textColor = TX_RGB(90, 90, 90);
        cell.textLabel.font = TX_FONT(15);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"20 May 2017 • 11:00am - 2:00pm";
        
        if (indexPath.row<_booking.times.count) {
            NSString *string = _booking.times[indexPath.row];
            string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            cell.textLabel.text = [self configStartDate:[string componentsSeparatedByString:@" - "][0] endDate:[string componentsSeparatedByString:@" - "][1]];
        }
        
        return cell;
    }else if(indexPath.section == SectionTypeADDRESS){
        BookingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingAddressCell" 
                                                               forIndexPath:indexPath];
        
        cell.lbAddress.text =_booking.shareAddress;
        if (((BookingState)(self.booking.bookingStatus.integerValue)) == BookingStateCONFIRMED) {
            
            cell.btnGetDirection.hidden = NO;
            if ([_booking.shareAddress containsString:ADDRESS_SEPARATED_STRING]) {
                cell.lbAddress.text = [self.booking.shareAddress stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","];
            }
        }else{
            cell.btnGetDirection.hidden = YES;
            if ([_booking.shareAddress containsString:ADDRESS_SEPARATED_STRING]) {
                cell.lbAddress.text = [_booking.shareAddress componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
            }
        }
        
        
        cell.lat = _booking.addressLat;
        cell.lon = _booking.addressLon;
        cell.lbTitle.text = @"Address";
        
        if (_booking.careType.integerValue == 2 && indexPath.row==1) {
            cell.lat = _booking.whereToMeetLat;
            cell.lon = _booking.whereToMeetLon;
            cell.lbTitle.text = @"Where to Meet";
            cell.lbAddress.text = _booking.whereToMeet;
            if (((BookingState)(self.booking.bookingStatus.integerValue)) == BookingStateCONFIRMED) { 
                cell.btnGetDirection.hidden = NO;
                if ([_booking.whereToMeet containsString:ADDRESS_SEPARATED_STRING]) {
                    cell.lbAddress.text = [self.booking.whereToMeet stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","]; 
                }
            }else{
                cell.btnGetDirection.hidden = YES;
                if ([_booking.whereToMeet containsString:ADDRESS_SEPARATED_STRING]) {
                    cell.lbAddress.text = [_booking.whereToMeet componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
                }
            }
        }
        cell.getDirectionBlock = ^(double lon, double lat) {
            [weakSelf requestDirectiondestination:CLLocationCoordinate2DMake(lat, lon)];
        };
        return cell;
    }else if(indexPath.section == SectionTypeWHOSCOIMG){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"booking" forIndexPath:indexPath];
        cell.textLabel.textColor = TX_RGB(90, 90, 90);
        cell.textLabel.font = TX_FONT(20);
        cell.textLabel.text = @"Attendee/s";
        cell.indentationLevel = 1.5;
        return cell;
    }else if(indexPath.section == SectionTypeCHILDRENS){
        WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                               forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ChildrenModel *children = [ChildrenModel modelWithDictionary:_booking.whoIsComings[indexPath.row]];
      //  children.state = ChildStateConfirmed; 
        cell.child = children; 
        cell.minBtn.hidden = YES;
        cell.lbStatus.hidden = ((BookingState)(self.booking.bookingStatus.integerValue)) == BookingStatePENDING; 
        return cell;
    }else if(indexPath.section == SectionTypePAYINFO){
        BookingAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingAmountCell" 
                                                                   forIndexPath:indexPath];
        cell.lbTotal.text = [NSString stringWithFormat:@"$%@ AUD",_booking.totalPrice];
        cell.lbBookingCode.text = _booking.bookingCode;
        return cell;
    }else if(indexPath.section == SectionTypeMESSAGE){
        BookingMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingMessageCell" 
                                                                   forIndexPath:indexPath];
        cell.userName = _booking.pubUserName;
        
        if (_booking.careType.integerValue == 2) {
            cell.lbTitle.text = [NSString stringWithFormat:@"%@ is hosting this Event",_booking.pubUserName];
        }
        
        cell.delegate = self;
        [cell.imgheader setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.pubUserIcon)] placeholderImage:kDEFAULT_HEAD_IMAGE];
        return cell;
        
    }else if(indexPath.section == SectionTypeCANCELBOOKING){
        BookingCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingCancelCell" 
                                                                   forIndexPath:indexPath];
        cell.cancelBlock = ^{
            [self showCancelAlert];
        };
        return cell;
        
    }else if(indexPath.section == SectionTypeCANCELEVENT){
        EventCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCancelCell" 
                                                                  forIndexPath:indexPath];
        
        cell.lbTitle.frame = CGRectMake(cell.lbTitle.frame.origin.x, 10, 300, 40);
        cell.btnCancel.frame = CGRectMake(cell.lbTitle.frame.origin.x, CGRectGetMaxY(cell.lbTitle.frame), 200, 30);
        cell.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.lbTitle.text = @"Cancel Event Attendance";
        cell.cancelBlock = ^{
            [self showCancelAlert];
        };
        return cell;
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (indexPath.section == SectionTypeCANCELEVENT) {
        [self showCancelAlert];
    }
   
}

- (void)contactShareCarer{
    ChatViewController *detail = [[ChatViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.toUserName = _booking.pubUserName;
    detail.toUser = _booking.pubAccountId;
    detail.toUserIcon = _booking.pubUserIcon;
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)accept:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    [ShareCareHttp GET:API_BOOKING_CONFIRM 
         withParaments:@[self.booking.bookingId] 
      withSuccessBlock:^(id response) {
        // if(count==9)
      ///  [self.navigationController popViewControllerAnimated:YES];
          
      //    BookingState state = (BookingState)(response);
          
        //  weakSelf.booking.bookingStatus = [NSString stringWithFormat:@"%lu",(unsigned long)BookingStateCONFIRMED];
          weakSelf.booking.bookingStatus = [NSString stringWithFormat:@"%@",response];
          if (weakSelf.delegate) {
              [weakSelf.delegate booking:weakSelf.booking atIndex:weakSelf.row];
          }
          [weakSelf updateUI];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
       
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (IBAction)decline:(id)sender {
    
    DeclineBookingDetailVC *detail = [[DeclineBookingDetailVC alloc] init];
    detail.booking = self.booking;
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)cacncel:(id)sender {
    
 
    
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    [ShareCareHttp GET:API_BOOKING_CANCEL 
         withParaments:@[self.booking.bookingId] 
      withSuccessBlock:^(id response) {
          // if(count==9)
          ///  [self.navigationController popViewControllerAnimated:YES];
          weakSelf.booking.bookingStatus = [NSString stringWithFormat:@"%lu",(unsigned long)BookingStateCANCEL];
          if (weakSelf.delegate) {
              [weakSelf.delegate booking:weakSelf.booking atIndex:weakSelf.row];
          }
          [weakSelf updateUI];
          [SVProgressHUD dismiss];
      } withFailureBlock:^(NSString *error) {
          
          [SVProgressHUD showErrorWithStatus:error];
      }];
}

- (void)updateUI{ 
    
    _bookingState = [_booking.bookingStatus integerValue];
    switch (_bookingState) {
        case BookingStatePENDING:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is pending. "];
        }
            break;
        case BookingStateCONFIRMED:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is confirmed! "];
        }
            break;
            
        case BookingStateDECLINED:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is declined. "];
        }
            break;
            
        case BookingStateTransactionFailed:{
            self.lbTitle.text = [NSString stringWithFormat:@"Transaction failed! "];
        }
            break;
            
        case BookingStateEXPIRED:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is expired. "];
        }
            break;
            
        case BookingStateRUNNING:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is confirmed! "];
        }
            break;
            
        case BookingStateINREVIEW:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is in review! "];
        }
            break;
            
        case BookingStateCURRENTLY_NOT_RUNNING:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is canceled! "];
        }
            break;
            
        case BookingStateCANCEL:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is canceled! "];
        }
            break;
            
        case BookingStateCOMPLETED:{
            self.lbTitle.text = [NSString stringWithFormat:@"Your booking is completed! "];
        }
            break;
            
            
        default:
            break;
    }
    
    
    if (self.booking.careType.integerValue == 2) {
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"Your booking" withString:@"Your event attendance"];
    }
    
    self.lbTitle.textColor = [self titleColor];
    [self.tableView reloadData];
}

- (void)declineBooking:(BookingModel *)book{
    self.booking.bookingStatus = [NSString stringWithFormat:@"%lu",(unsigned long)BookingStateDECLINED];
    [self updateUI];
    
    if (_delegate) {
        [_delegate booking:self.booking atIndex:_row];
    }
}
- (void)showCancelAlert{
    
    
    __block typeof(self) weakeSelf = self;
    
    NSString *messageText = nil;
    if (self.booking.totalPrice.floatValue>0) {
        messageText = @"A 50% cancellation fee will apply if you cancel 24 hours before a confirmed booking.";
    }
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"Are you sure you want to cancel this booking?"
                                          message:messageText 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go Back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes,Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf cacncel:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (NSString *)configStartDate:(NSString *)start endDate:(NSString *)end{
    
    
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *startTime = [dateFormatter stringFromDate:startDate];
    NSString *endTime = [dateFormatter stringFromDate:endDate];
    
    
    startTime = [startTime stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    startTime = [startTime stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    endTime = [endTime stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    endTime = [endTime stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateStr = [dateFormatter stringFromDate:startDate];
    
    return [NSString stringWithFormat:@"%@ • %@",dateStr,timeStr];
}            
- (IBAction)visitHelpCentre:(id)sender {
    HelpAndSupportVC *create  = [[HelpAndSupportVC alloc] init];
    create.title = @"";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
    
}

@end

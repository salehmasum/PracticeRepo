//
//  PSCListingsDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2018/5/15.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "PSCListingsDetailVC.h"
#import "ShareCareModel.h"
#import "BabysittingModel.h"
#import "EventModel.h"


@interface PSCListingsDetailVC (){
    
}
@property (strong, nonatomic) ShareCareModel *shareCare;
@end

@implementation PSCListingsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.tableView.tableFooterView = [UIView new];
//    self.lbTitle.hidden = YES; 
     
    
    self.headViewLine.hidden  = YES;
    [self loadData:_item];
    
  
} 
- (void)loadData:(id)listing{
     
    
    ShareCareModel *model = (ShareCareModel *)listing;
    self.booking = [[BookingModel alloc] init]; 
    self.booking.bookingStatus = model.shareCareStatus;
    self.booking.shareIcon = model.photosPath;
    self.booking.careType = @"0";
    self.booking.totalPrice = model.moneyPerDay;
    self.booking.pubUserName = model.userName;
    self.booking.pubUserIcon = model.userIcon;
    self.booking.shareAddress = model.address;
    self.booking.addressLat = model.addressLat;
    self.booking.addressLon = model.addressLon;
    self.booking.shareIcon = model.photosPath; 
    self.booking.typeId = model.idValue;
    [self requestBookingChild:[NSString stringWithFormat:@"%@",model.idValue] careType:@"0"];
    
    
    [self reloadData];
  //  self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"booking" withString:@"listing"];
   // self.tableView.tableFooterView = [UIView new];
}
 
//获取已参加的小孩
- (void)requestBookingChild:(NSString *)listId careType:(NSString *)type{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_APPOINTED_CHILD 
         withParaments:@[type,listId] 
      withSuccessBlock:^(id response) {
          
          if ([response isKindOfClass:[NSArray class]]) {
              NSMutableArray *childrens = [NSMutableArray array];
              NSArray *array = (NSArray *)response;
              for (id obj in array) {
                  ChildrenModel *child = [ChildrenModel modelWithDictionary:obj];
                  //   child.state = ChildStateConfirmed;
                  [childrens addObject:child];
              }
              weakSelf.booking.whoIsComings = childrens;
              
          } else{
              
              weakSelf.booking.whoIsComings = @[];
          }
          [weakSelf.tableView reloadData];
      } withFailureBlock:^(NSString *error) {
          
      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == SectionTypePAYINFO) {
        return 90;
    }
    if (indexPath.section == SectionTypeCANCELBOOKING) {
        return 80;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == SectionTypeTIMES) {
        return 0;
    }
     
    if (section == SectionTypeMESSAGE) {
        return 0;
    }
    if (section == SectionTypeCANCELBOOKING) {
        if (((ShareCareModel *)self.item).shareCareStatus.integerValue==4) {
            return 1;
        }
        return 0; 
    }  
    if (section == SectionTypeCHILDRENS) {
        return self.booking.whoIsComings.count?self.booking.whoIsComings.count:1;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == SectionTypeCHILDRENS){
        WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                               forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.booking.whoIsComings.count) {
            ChildrenModel *children = self.booking.whoIsComings[indexPath.row];
            children.isMyChild = YES;
            cell.child = children;
            cell.lbAge.text = children.fullName;
            cell.lbStatus.text = children.age;
            cell.icon.hidden = NO;
            cell.lbAge.font = TX_FONT(21);
            
        }else{
            cell.lbAge.text = @"No attendees yet";
            cell.lbAge.textColor = COLOR_GRAY;
            cell.lbAge.font = TX_BOLD_FONT(21);
            cell.lbStatus.text = @"";
            cell.icon.hidden = YES;
        }
        cell.lbStatus.hidden = [self.booking.bookingStatus integerValue]==0;
        cell.minBtn.hidden = YES; 
        return cell;
    }
    if(indexPath.section == SectionTypePAYINFO){
        BookingAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingAmountCell" 
                                                                  forIndexPath:indexPath];
        cell.lbTotal.text = [NSString stringWithFormat:@"$%@ AUD",self.booking.totalPrice]; 
        cell.lbAmount.text = @"Charge";
        cell.lbBookingCode.hidden = YES;
        cell.lbBookingCodeTitle.hidden = YES;
        cell.imgBottomLine.hidden = YES;
        return cell;
    }
    
    if(indexPath.section == SectionTypeCANCELBOOKING){
        EventCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCancelCell" 
                                                                forIndexPath:indexPath];
         
        cell.btnCancel.frame = CGRectMake(cell.lbTitle.frame.origin.x, CGRectGetMinY(cell.lbTitle.frame), 200, 30);
        cell.lbTitle.hidden = YES;
        [cell.btnCancel setTitle:@"Cancel Listing" forState:UIControlStateNormal];
        cell.btnCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        cell.cancelBlock = ^{
            [self showCancelAlertwithTitle:@"Are you sure you want to cancel this listing?"];
        };
        return cell;
        
    }
    if(indexPath.section == SectionTypeCANCELEVENT){
        EventCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCancelCell" 
                                                                forIndexPath:indexPath];
        
        
        cell.lbTitle.text = @"Cancel Event";
        cell.cancelBlock = ^{
            [self showCancelAlertwithTitle:@"Are you sure you want to cancel this event?"];
        };
        return cell;
        
    }
    if(indexPath.section == SectionTypeADDRESS){
        BookingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingAddressCell" 
                                                                   forIndexPath:indexPath];
        
        cell.lbAddress.text = [self.booking.shareAddress stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","]; 
        cell.lat = self.booking.addressLat;
        cell.lon = self.booking.addressLon;
        cell.lbTitle.text = @"Address";
        
        if (self.booking.careType.integerValue == 2 && indexPath.row==1) {
            cell.lat = self.booking.whereToMeetLat;
            cell.lon = self.booking.whereToMeetLon;
            cell.lbTitle.text = @"Where to Meet";
            cell.lbAddress.text = [self.booking.whereToMeet stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","]; 
        }
        
        cell.btnGetDirection.hidden = NO;//self.booking.careType.integerValue==0;
        cell.getDirectionBlock = ^(double lon, double lat) {
            [self requestDirectiondestination:CLLocationCoordinate2DMake(lat, lon)];
        };
        return cell;
    }
     
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)showCancelAlertwithTitle:(NSString *)title{
    
    
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:title
                                          message:@"" 
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

- (void)cacncel:(id)sender{
    
    [SVProgressHUD showWithStatus:TEXT_LOADING];  
    [ShareCareHttp GET:@"/v1/sharecare/list/cancel/" withParaments:@[self.booking.careType,[NSString stringWithFormat:@"%@",self.booking.typeId]] withSuccessBlock:^(id response) {
        
        if (_cancelListingBlock) {
            if ([self.item isKindOfClass:[ShareCareModel class]]) {  
                ((ShareCareModel *)self.item).shareCareStatus= @"6"; 
                _cancelListingBlock(self.item);
            }else if ([self.item isKindOfClass:[BabysittingModel class]]){  
                ((BabysittingModel *)self.item).babysittingStatus= @"6";
                _cancelListingBlock(self.item);
            }else if ([self.item isKindOfClass:[EventModel class]]){  
                ((EventModel *)self.item).eventStatus= @"6";
                _cancelListingBlock(self.item);
            } 
             
        }
        [self loadData:self.item];
      //  [self.tableView reloadData];
      //  [self.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        
    }];
    
}

- (void)updateUI{
    self.bookingState = [self.booking.bookingStatus integerValue];
    switch (self.bookingState) {
        case BookingStatePENDING:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is pending. "];
        }
            break;
        case BookingStateCONFIRMED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is confirmed! "];
        }
            break;
            
        case BookingStateDECLINED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is declined. "];
        }
            break;
            
        case BookingStateEXPIRED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is expired. "];
        }
            break;
            
        case BookingStateRUNNING:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is published. "];
        }
            break;
            
        case BookingStateINREVIEW:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is in review! "];
        }
            break;
            
        case BookingStateCURRENTLY_NOT_RUNNING:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing has been cancelled! "];
        }
            break;
            
        case BookingStateCANCEL:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is canceled! "];
        }
            break;
            
        case BookingStateCOMPLETED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This listing is completed! "];
        }
            break;
            
            
        default:
            break;
    }
    if (self.booking.careType.integerValue == 0) {
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"This listing" withString:@"Your listing"]; 
    }
    
    if (self.booking.careType.integerValue == 2) {
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"This listing" withString:@"Your event"];
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"Your listing" withString:@"Your event"];
    }
    
    self.lbTitle.textColor = [self titleColor];
    [self.tableView reloadData];
}
@end

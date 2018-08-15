//
//  MyBookingsDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MyBookingsDetailVC.h"
#import "EventCancelCell.h"
#import "BookingCancelCell.h"
@interface MyBookingsDetailVC ()

@end

@implementation MyBookingsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self updateUI];
}

- (void)updateUI{
    
    [super updateUI];
    
    if (self.booking.bookingStatus.integerValue == BookingStatePENDING) {
        self.btnAccept.hidden = NO;
        self.btnDecline.hidden = NO;
        self.infinitePageView.frame = CGRectMake(0, (60+70)*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, 188*TX_SCREEN_OFFSET);
        self.userHeaderImageView.frame = CGRectMake(TX_SCREEN_WIDTH-76*TX_SCREEN_OFFSET-20, ((60+188+80)*TX_SCREEN_OFFSET)-38*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET);
        self.headerView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, 400*TX_SCREEN_OFFSET);
        [self.headerView layoutIfNeeded];
    }else{
        self.btnAccept.hidden = YES;
        self.btnDecline.hidden = YES;
        self.infinitePageView.frame = CGRectMake(0, 60*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, 188*TX_SCREEN_OFFSET);
        self.userHeaderImageView.frame = CGRectMake(TX_SCREEN_WIDTH-76*TX_SCREEN_OFFSET-20, ((60+188)*TX_SCREEN_OFFSET)-38*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET);
        self.headerView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, 320*TX_SCREEN_OFFSET);
        [self.headerView layoutIfNeeded];
    }
    [self.tableView setTableHeaderView:self.headerView];
    
    if (self.booking.careType.integerValue == 2) {
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@" attendance" withString:@""];
    }
    
    self.bookingState = [self.booking.bookingStatus integerValue];
    switch (self.bookingState) {
        case BookingStatePENDING:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking is pending. "];
        }
            break;
        case BookingStateCONFIRMED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking is confirmed! "];
        }
            break;
            
        case BookingStateDECLINED:{
            self.lbTitle.text = [NSString stringWithFormat:@"You have declined this booking. "];
        }
            break;
            
        case BookingStateEXPIRED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking has expired. "];
        }
            break;
            
        case BookingStateRUNNING:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking is published. "];
        }
            break;
            
        case BookingStateINREVIEW:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking is in review! "];
        }
            break;
            
        case BookingStateCURRENTLY_NOT_RUNNING:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking has been cancelled! "];
        }
            break;
            
        case BookingStateCANCEL:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking is canceled! "];
        }
            break;
            
        case BookingStateCOMPLETED:{
            self.lbTitle.text = [NSString stringWithFormat:@"This booking is completed! "];
        }
            break;
            
        case BookingStateTransactionFailed:{
            self.lbTitle.text = [NSString stringWithFormat:@"Transaction failed! "];
        }
            break;
            
            
        default:
            break;
    }
    
    
    if (self.booking.careType.integerValue == 0) {
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"This booking" withString:@"Your booking"]; 
    }
    
    if (self.booking.careType.integerValue == 2) {
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"This booking" withString:@"Your event"];
        self.lbTitle.text = [self.lbTitle.text stringByReplacingOccurrencesOfString:@"Your booking" withString:@"Your event"];
    }
    
    self.lbTitle.textColor = [self titleColor];
    [self.tableView reloadData];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.booking.bookingStatus.integerValue == BookingStatePENDING) {
        if (section == SectionTypeCANCELEVENT || 
            section == SectionTypeCANCELBOOKING ||
            section == SectionTypeMESSAGE) {
            return 0;
        }
    }
    if (self.booking.bookingStatus.integerValue == BookingStateCONFIRMED) {
        if (section == SectionTypeMESSAGE) {
            return 0;
        }
    }
    if (section == SectionTypeMESSAGE) {
        return 0;
    }
    
    if (self.booking.bookingStatus.integerValue == BookingStateDECLINED) {
        if (section == SectionTypeCANCELEVENT || section == SectionTypeCANCELBOOKING) {
            return 0;
        }
    }
    
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeCANCELEVENT) return 68;
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionTypeCANCELEVENT) {
        EventCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCancelCell" 
                                                                forIndexPath:indexPath];
        cell.lbTitle.text = @"Cancel Event";
        cell.cancelBlock = ^{
            [self showCancelAlert];
        };
        return cell;
    }
    if(indexPath.section == SectionTypeCANCELBOOKING){
        BookingCancelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingCancelCell" 
                                                                  forIndexPath:indexPath];
        cell.lbTitle.text = @"Cancel Booking";
        cell.cancelBlock = ^{
            [self showCancelAlert];
        };
        return cell;
        
    }
    if(indexPath.section == SectionTypeWHOSCOIMG && 
       (self.booking.bookingStatus.integerValue==BookingStateEXPIRED ||
        self.booking.bookingStatus.integerValue==BookingStateDECLINED)){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"booking" forIndexPath:indexPath];
        cell.textLabel.textColor = TX_RGB(90, 90, 90);
        cell.textLabel.font = TX_FONT(20);
        cell.textLabel.text = @"Requested Attendee/s";
        cell.indentationLevel = 1.5;
        return cell;
    }
    if(indexPath.section == SectionTypeCHILDRENS){
        WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                               forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ChildrenModel *children = [ChildrenModel modelWithDictionary:self.booking.whoIsComings[indexPath.row]]; 
        children.isMyChild = YES; 
        cell.child = children;
        //        cell.lbAge.text = children.fullName;
        cell.lbStatus.text = children.age;
        cell.minBtn.hidden = YES;
        
        cell.lbStatus.hidden = [self.booking.bookingStatus integerValue]==0;
        return cell;
    }
    if(indexPath.section == SectionTypeADDRESS){
        BookingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingAddressCell" 
                                                                   forIndexPath:indexPath];
        
        cell.lbAddress.text = [self.booking.shareAddress stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","];
        cell.btnGetDirection.hidden = NO;
//        if (((BookingState)(self.booking.bookingStatus.integerValue)) == BookingStateCONFIRMED) {
//            
//            cell.btnGetDirection.hidden = NO;
//            if ([self.booking.shareAddress containsString:ADDRESS_SEPARATED_STRING]) {
//                cell.lbAddress.text = [self.booking.shareAddress stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","];
//            }
//        }else{
//            cell.btnGetDirection.hidden = YES;
//            if ([self.booking.shareAddress containsString:ADDRESS_SEPARATED_STRING]) {
//                cell.lbAddress.text = [self.booking.shareAddress componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
//            }
//        }
        
        
        cell.lat = self.booking.addressLat;
        cell.lon = self.booking.addressLon;
        cell.lbTitle.text = @"Address";
        
        if (self.booking.careType.integerValue == 2 && indexPath.row==1) {
            cell.lat = self.booking.whereToMeetLat;
            cell.lon = self.booking.whereToMeetLon;
            cell.lbTitle.text = @"Where to Meet"; 
            
            cell.btnGetDirection.hidden = NO;
            cell.lbAddress.text = [self.booking.whereToMeet stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","]; 
//            if (((BookingState)(self.booking.bookingStatus.integerValue)) == BookingStateCONFIRMED) { 
//                cell.btnGetDirection.hidden = NO;
//                if ([self.booking.whereToMeet containsString:ADDRESS_SEPARATED_STRING]) {
//                    cell.lbAddress.text = [self.booking.whereToMeet stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","]; 
//                }
//            }else{
//                cell.btnGetDirection.hidden = YES;
//                if ([self.booking.whereToMeet containsString:ADDRESS_SEPARATED_STRING]) {
//                    cell.lbAddress.text = [self.booking.whereToMeet componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
//                }
//            }
        }
        
        cell.btnGetDirection.hidden = self.booking.careType.integerValue==0;
        cell.getDirectionBlock = ^(double lon, double lat) {
            [self requestDirectiondestination:CLLocationCoordinate2DMake(lat, lon)];
        };
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
- (void)cacncel:(id)sender {
    
    NSDateFormatter *dateformatter = [Util dateFormatter];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    
    
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    [ShareCareHttp GET:@"/v1/booking/cancel/" withParaments:@[[dateformatter stringFromDate:[NSDate date]],self.booking.careType,[NSString stringWithFormat:@"%@",self.booking.typeId]] withSuccessBlock:^(id response) {
        self.booking.bookingStatus = [NSString stringWithFormat:@"%lu",(unsigned long)BookingStateCANCEL];
        if (self.delegate) {
            [self.delegate booking:self.booking atIndex:self.row]; 
        }
        [self updateUI];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        
    }];
}
@end

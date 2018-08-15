//
//  BUpcomingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BUpcomingVC.h"
#import "UpcomingCell.h"
#import "BookingPaymentReceiptVC.h"
#import "BookingReviewVC.h"
@interface BUpcomingVC (){
    
    NSInteger _selectedRow;
}

@end

@implementation BUpcomingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UpcomingCell  class]) bundle:nil] forCellReuseIdentifier:@"upcoming"];
    self.status = BookingStatusUpcoming;
}

- (NSString *)api{
    return API_BOOKING_UPCOMING_LIST;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpcomingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upcoming" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.row = indexPath.row;
    BookingModel *booking = self.dataSource[indexPath.row];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(booking.thumbnail)] 
                  placeholderImage:kDEFAULT_IMAGE];
    cell.lbCaretype.text = booking.careType.integerValue==0?@"EleCare":(booking.careType.integerValue==1?@"Babysitting":@"Events");
    // cell.lbDate
    
    if (booking.bookingStatus.integerValue == BookingStateCONFIRMED) {   
        cell.lbAddress.text = [booking.shareAddress stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","]; 
    }else{
        cell.lbAddress.text = [booking.shareAddress componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
    }
    
    [cell configStartDate:booking.startDate endDate:booking.endDate]; 
    cell.imgState.image = BOOKING_IMAGE_STATE([booking.bookingStatus integerValue]);
    cell.moreButton.hidden = booking.careType.integerValue==2;//屏蔽Event
    cell.selectedBlock = ^(NSInteger row) {
        [self showAlertAtRow:row];  
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedRow = indexPath.row;
     
    
    BookingModel *booking = self.dataSource[_selectedRow];
    
    BookingDetailVC *detail  = [[BookingDetailVC alloc] init];
    detail.hidesBottomBarWhenPushed = YES; 
    detail.bookingId = booking.bookingId;
    detail.delegate = self;
    detail.row = _selectedRow;
    [self.navigationController pushViewController:detail animated:YES];
//    
}
- (void)showAlertAtRow:(NSInteger)row{
     
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:nil 
                                          message:nil 
                                          preferredStyle:UIAlertControllerStyleActionSheet]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *sharecareAction = [UIAlertAction actionWithTitle:@"Payment Receipt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf paymentReceiptAtRow:row];
    }];
    [alertController addAction:sharecareAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)paymentReceiptAtRow:(NSInteger)row{
    BookingModel *booking = self.dataSource[row]; 
    NSLog(@"%@",URLStringForPath(booking.userIcon));
    
    BookingPaymentReceiptVC *create  = [[BookingPaymentReceiptVC alloc] init];
    create.hidesBottomBarWhenPushed = YES;
    create.booking = booking;
    [self.navigationController pushViewController:create animated:YES];
}
- (void)booking:(BookingModel *)booking atIndex:(NSInteger)row{
 //   UpcomingCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
     [self.dataSource replaceObjectAtIndex:row withObject:booking];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}


@end

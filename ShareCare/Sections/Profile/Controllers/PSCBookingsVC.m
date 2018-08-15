//
//  PSCBookingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PSCBookingsVC.h"
#import "MyBookingsDetailVC.h"

@interface PSCBookingsVC ()<BookingStateDidChangedDelegate>

@end

@implementation PSCBookingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_WHITE;
    self.tableView.tableFooterView = [UIView new];
    self.headerTitleLabel.textColor = COLOR_GRAY;
    self.headerTitleLabel.font = TX_FONT(15);
}
- (void)resetUI{
    if (self.dataSource.count) {
        self.tableView.tableHeaderView = [UIView new];
    }else{
        self.tableView.tableHeaderView = self.headerView;
    }
}
- (NSString *)headerTitleText{
    return @"";
}
- (NSString *)headerDescText{
    return @"You have no upcoming reservations.";
}
- (NSString *)api{
    return [NSString stringWithFormat:@"%@shareType=0&",API_BOOKING_OTHERS_LIST];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpcomingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upcoming" forIndexPath:indexPath];
    
    // Configure the cell...
    
    BookingModel *booking = self.dataSource[indexPath.row];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(booking.thumbnail)] 
                  placeholderImage:kDEFAULT_IMAGE];
    cell.lbCaretype.text = booking.careType.integerValue==0?@"EleCare":(booking.careType.integerValue==1?@"Babysitting":@"Events");
    // cell.lbDate
    cell.lbAddress.text = [booking.shareAddress componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
    [cell configStartDate:booking.startDate endDate:booking.endDate]; 
    cell.imgState.image = BOOKING_IMAGE_STATE([booking.bookingStatus integerValue]);
    cell.moreButton.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BookingModel *booking = self.dataSource[indexPath.row];
    MyBookingsDetailVC *detail  = [[MyBookingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
    detail.hidesBottomBarWhenPushed = YES;
   // detail.booking = booking;
    detail.bookingId = booking.bookingId;
    detail.row = indexPath.row;
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)booking:(BookingModel *)booking atIndex:(NSInteger)row{
    [self.dataSource replaceObjectAtIndex:row withObject:booking];
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
  //  [self loadPage:0];
}

@end

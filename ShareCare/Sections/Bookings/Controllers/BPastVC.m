//
//  BPastVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BPastVC.h"
#import "PastCell.h"
#import "BookingReviewVC.h"
#import "BookingPaymentReceiptVC.h"
#import "BookingDetailVC.h"
@interface BPastVC ()<BookingAddReviewDelegate>{
    NSInteger _selectedRow;
}

@end

@implementation BPastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PastCell  class]) bundle:nil] forCellReuseIdentifier:@"past"];
    
    self.status = BookingStatusPast;
}

- (NSString *)api{
    return API_BOOKING_PAST_LIST;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"past" forIndexPath:indexPath];
    
    // Configure the cell...
    __block typeof(self) weakeSelf = self;
    
    cell.row = indexPath.row;
    cell.selectedBlock = ^(id object) {
        
        _selectedRow = cell.row;
        [weakeSelf showAlert];
    }; 
    BookingModel *booking = self.dataSource[indexPath.row];
    [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(booking.thumbnail)] 
                  placeholderImage:kDEFAULT_IMAGE];
    cell.lbCaretype.text = booking.careType.integerValue==0?@"EleCare":(booking.careType.integerValue==1?@"Babysitting":@"Events");
   // cell.lbDate
    cell.lbAddress.text = [booking.shareAddress componentsSeparatedByString:ADDRESS_SEPARATED_STRING].firstObject;
    [cell configStartDate:booking.startDate endDate:booking.endDate]; 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedRow = indexPath.row;
    
    [self showAlert];
}

- (void)showAlert{
    
    BookingModel *booking = self.dataSource[_selectedRow];
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:nil 
                                          message:nil 
                                          preferredStyle:UIAlertControllerStyleActionSheet]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    if (booking.careType.integerValue !=2) {
        UIAlertAction *sharecareAction = [UIAlertAction actionWithTitle:@"Payment Receipt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
            [weakeSelf paymentReceipt:@"Payment Receipt"];
        }];
        [alertController addAction:sharecareAction];
    }
    
    UIAlertAction *babySittingAction = [UIAlertAction actionWithTitle:@"Re-book" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf rebook:@"Re-book"];
    }];
    [alertController addAction:babySittingAction];
    
    if (booking.hasReview == NO && booking.careType.integerValue != 2) {
        UIAlertAction *eventAction = [UIAlertAction actionWithTitle:@"Review" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
            [weakeSelf review:@"Review"];
        }]; 
        [alertController addAction:eventAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)paymentReceipt:(NSString *)text{
    
    
    BookingModel *booking = self.dataSource[_selectedRow]; 
    NSLog(@"%@",URLStringForPath(booking.userIcon));
    
    BookingPaymentReceiptVC *create  = [[BookingPaymentReceiptVC alloc] init];
    create.hidesBottomBarWhenPushed = YES;
    create.booking = booking;
    [self.navigationController pushViewController:create animated:YES];
}

- (void)rebook:(NSString *)text{
    
    BookingModel *object = self.dataSource[_selectedRow];
    NSString *api;
    if ([object.careType integerValue] == 0) {
        api = API_SHARECARE_DETAIL;
    }else if ([object.careType integerValue] == 1){ 
        api = API_BABYSITTING_DETAIL;
    }else if ([object.careType integerValue] == 2){ 
        api = API_EVENT_DETAIL;
    } 
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    [ShareCareHttp GET:api withParaments:@[object.typeId] withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            [self switchToDetailController:object.careType.integerValue andItem:response];  
        }
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)review:(NSString *)text{
    
    BookingModel *model = self.dataSource[_selectedRow];
    BookingReviewVC *reviewVC  = [[BookingReviewVC alloc] init];
    reviewVC.hidesBottomBarWhenPushed = YES;
    reviewVC.booking = self.dataSource[_selectedRow];
    reviewVC.bookingId = model.bookingId;
    reviewVC.delegate = self;
    [self.navigationController pushViewController:reviewVC animated:YES];
}
- (void)addReviewWith:(BookingModel *)booking{ 
    booking.hasReview= YES;
    [self.dataSource replaceObjectAtIndex:_selectedRow withObject:booking];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)switchToDetailController:(NSInteger)careType andItem:(id)item{
    HBaseDetailVC *presentViewController ;//
    
    BookingModel *object = self.dataSource[_selectedRow];
    if ([object.careType integerValue] == 0) {
        presentViewController = [HShareCareDetailVC new];
        presentViewController.item = [ShareCareModel modelWithDictionary:item];
    }else if ([object.careType integerValue] == 1){ 
        presentViewController = [HBabysittingDetailVC new];
        presentViewController.item = [BabysittingModel modelWithDictionary:item];
    }else if ([object.careType integerValue] == 2){ 
        presentViewController = [HEventDetailVC new];
        presentViewController.item = [EventModel modelWithDictionary:item];
    } 
    presentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:presentViewController animated:YES];
}

@end

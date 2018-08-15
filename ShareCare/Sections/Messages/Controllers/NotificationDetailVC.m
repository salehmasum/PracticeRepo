//
//  NotificationDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NotificationDetailVC.h"
#import "DeclineReasonCell.h"
#import "NotificationButtonCell.h"
#import "BookingMessageCell.h"
#import "ChatViewController.h"
#import "HBaseDetailVC.h"
#import "HShareCareDetailVC.h"
#import "HBabysittingDetailVC.h"
#import "HEventDetailVC.h"
#import "HelpAndSupportVC.h"
@interface NotificationDetailVC ()
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;

@end

@implementation NotificationDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DeclineReasonCell class]) bundle:nil] forCellReuseIdentifier:@"DeclineReasonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NotificationButtonCell class]) bundle:nil] forCellReuseIdentifier:@"NotificationButtonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BookingMessageCell class]) bundle:nil] forCellReuseIdentifier:@"BookingMessageCell"];
    
    self.tableView.tableHeaderView = _headerView;
    self.tableView.tableFooterView = _footerView;
     
    [self requestBookingDetail];
}
- (void)requestBookingDetail{
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_DETAIL withParaments:@[_bookingId] withSuccessBlock:^(id response) {
        
        weakSelf.booking = [BookingModel modelWithDictionary:response]; 
        
        [weakSelf reloadData]; 
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)reloadData{
    if (self.bookingState == BookingStateEXPIRED) { 
        _lbSubTitle.text = [NSString stringWithFormat:@"%@ didn’t respond with 24hrs. You can send her another booking request. ",self.booking.userName];
    }else if (self.bookingState == BookingStateDECLINED){ 
        NSInteger careType = [self.booking.careType integerValue];
        _lbSubTitle.text = [NSString stringWithFormat:@"More %@ listings available nearby.",careType==0?@"EleCare":(careType==1?@"Babysitting":@"Events")];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  
    switch (section) {
        case 0:
            return 1+(self.bookingState == BookingStateEXPIRED);
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
            
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 74;
    }else if (indexPath.section == 1){
        return 166*TX_SCREEN_OFFSET;
    }else{
        return 145;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NotificationButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationButtonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // Configure the cell...
        
        if (self.bookingState == BookingStateEXPIRED) {
            [cell.btnSearch setTitle:indexPath.row?@"Keep Searching":@"Send another Request" 
                            forState:UIControlStateNormal];
        }else if (self.bookingState == BookingStateDECLINED){
            [cell.btnSearch setTitle:@"Keep Searching" forState:UIControlStateNormal];
        }
         
        return cell;
    }else if (indexPath.section == 1){
        DeclineReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeclineReasonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Configure the cell...
        cell.lbReason.text = _booking.rejectReason; 
        [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.pubUserIcon)] placeholderImage:kDEFAULT_HEAD_IMAGE];
        
        return cell;
    }else if (indexPath.section == 2){
        BookingMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingMessageCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        // Configure the cell...
        cell.userName = _booking.userName; 
        [cell.imgheader setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.pubUserIcon)] placeholderImage:kDEFAULT_HEAD_IMAGE];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.bookingState== BookingStateEXPIRED && indexPath.row == 0) {
            [self rebook:nil];
        }else{ 
            [self.navigationController popViewControllerAnimated:YES]; 
        }
    }
}
- (void)rebook:(NSString *)text{
     
    NSString *api;
    if ([self.booking.careType integerValue] == 0) {
        api = API_SHARECARE_DETAIL;
    }else if ([self.booking.careType integerValue] == 1){ 
        api = API_BABYSITTING_DETAIL;
    }else if ([self.booking.careType integerValue] == 2){ 
        api = API_EVENT_DETAIL;
    } 
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    [ShareCareHttp GET:api withParaments:@[self.booking.typeId] withSuccessBlock:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            [self switchToDetailController:self.booking.careType.integerValue andItem:response];  
        }
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)switchToDetailController:(NSInteger)careType andItem:(id)item{
    HBaseDetailVC *presentViewController ;//
     
    if ([self.booking.careType integerValue] == 0) {
        presentViewController = [HShareCareDetailVC new];
        presentViewController.item = [ShareCareModel modelWithDictionary:item];
    }else if ([self.booking.careType integerValue] == 1){ 
        presentViewController = [HBabysittingDetailVC new];
        presentViewController.item = [BabysittingModel modelWithDictionary:item];
    }else if ([self.booking.careType integerValue] == 2){ 
        presentViewController = [HEventDetailVC new];
        presentViewController.item = [EventModel modelWithDictionary:item];
    } 
    presentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:presentViewController animated:YES];
}
- (void)contactShareCarer{
    ChatViewController *detail = [[ChatViewController alloc] init]; 
    detail.toUserName = _booking.userName;
    detail.toUser = _booking.pubAccountId;
    detail.toUserIcon = _booking.userIcon;
    [self.navigationController pushViewController:detail animated:YES];
}
 
- (IBAction)visitHelpCentre:(id)sender {
    HelpAndSupportVC *create  = [[HelpAndSupportVC alloc] init];
    create.title = @"";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
}

@end

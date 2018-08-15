//
//  MNotificationsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MNotificationsVC.h"
#import "MNotificationCell.h"
#import "NotificationDetailVC.h"
#import "MyBookingsDetailVC.h"
@interface MNotificationsVC ()
//@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MNotificationsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setMessageBlockNil];
}

- (void)initData{
    self.dataSource = [NSMutableArray array];
    [self reloadList];
    [XMPPService sharedInstance].inboxNotificationBlock = ^(MessageModel *message) {
        [self reloadList];
    };
}

- (void)reloadList{
    self.dataSource = [[SQLHelper sharedInstance] selectNotificationList];
    [self.tableView reloadData];
    [self resetUI];
}

- (void)setMessageBlockNil{
    [XMPPService sharedInstance].inboxNotificationBlock = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MNotificationCell class]) bundle:nil] forCellReuseIdentifier:@"notification"];
    self.tableView.tableFooterView = [UIView new];
    self.lbNoData.text = @"No notifications yet"; 
}
- (void)setupRefresh{
    
} 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notification" forIndexPath:indexPath];
    
    // Configure the cell...
     
    MessageModel *message = self.dataSource[indexPath.row];
    NSString *content = message.content;
    NSArray *array = [content componentsSeparatedByString:@"!*#"];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(message.toUserIcon)] 
                       placeholderImage:kDEFAULT_HEAD_IMAGE];
    cell.namelabel.text = message.toUserName;
    cell.statusImageView.image = BOOKING_IMAGE_STATE([array[2] integerValue]);
    
    NSInteger careType = [array[3] integerValue];
    cell.typeLabel.text = careType==0?@"EleCare":(careType==1?@"Babysitting":@"Events");
    cell.notificationStatusImageView.hidden = message.isRead;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];  
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMessageStatusImage" object:nil];
    MessageModel *message = self.dataSource[indexPath.row];
    NSString *content = message.content;
    NSArray *array = [content componentsSeparatedByString:@"!*#"];
    id bookingId = array[1];
    id bookingState = array[2];
   // id bookingType = array[3];
    id pubAccountId = array.lastObject;
    if ([bookingState integerValue] == BookingStateDECLINED || [bookingState integerValue] == BookingStateEXPIRED) {
        NotificationDetailVC *detail = [[NotificationDetailVC alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        detail.bookingId = [NSString stringWithFormat:@"%@",bookingId];
        detail.bookingState = (BookingState)[bookingState integerValue];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        
        if ([[NSString stringWithFormat:@"%@",pubAccountId] isEqualToString:kUSER_ID]) {
            MyBookingsDetailVC *detail  = [[MyBookingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
            detail.hidesBottomBarWhenPushed = YES; 
            detail.bookingId = [NSString stringWithFormat:@"%@",bookingId];  
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            BookingDetailVC *detail  = [[BookingDetailVC alloc] init];
            detail.hidesBottomBarWhenPushed = YES; 
            detail.bookingId = bookingId;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"queryBookingDetail" object:bookingId];
        
    }
    
    message.isRead = YES;
    [[SQLHelper sharedInstance] updataMessage:message];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MessageModel *message = self.dataSource[indexPath.row];
        // 删除数据源的数据,self.cellData是你自己的数据
        [self.dataSource removeObjectAtIndex:indexPath.row];
        // 删除列表中数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        [[SQLHelper sharedInstance] deleteToUser:message.toUser];
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";//默认文字为 Delete
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

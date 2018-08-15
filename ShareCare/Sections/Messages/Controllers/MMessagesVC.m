//
//  MMessagesVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MMessagesVC.h"
#import "MMessageCell.h"
#import "ChatViewController.h"
@interface MMessagesVC (){
    
    UIView *_noDataView;
}
//@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation MMessagesVC

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
    [XMPPService sharedInstance].inboxMessageBlock = ^(MessageModel *message) {
        [self reloadList];
    };
    
}
- (void)reloadList{
    self.dataSource = [[SQLHelper sharedInstance] selectMessageList];
    [self.tableView reloadData];
    [self resetUI];
}

- (void)resetUI{
    if (self.dataSource.count == 0) {
        self.tableView.tableHeaderView = _noDataView;
    }else{
        self.tableView.tableHeaderView = [UIView new];
    }
}
- (void)setMessageBlockNil{
    [XMPPService sharedInstance].inboxMessageBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MMessageCell class]) bundle:nil] forCellReuseIdentifier:@"message"];
    self.tableView.tableFooterView = [UIView new];
    
    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 400)];
    UILabel *label = [[UILabel alloc] initWithFrame:_noDataView.bounds];
    label.textColor = TX_RGBA(90, 90, 90, 0.5);
    label.font = TX_BOLD_FONT(30);
    label.text = @"No messages yet"; 
    label.textAlignment = NSTextAlignmentCenter;
    [_noDataView addSubview:label];
}
- (void)refreshStateChange:(UIRefreshControl *)control{
    [control endRefreshing];
}
- (void)querySqlite{
   // _dataSource = [NSMutableArray array];
    
    self.dataSource = [[SQLHelper sharedInstance] selectMessageList];

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
    MMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    
    // Configure the cell... 
    MessageModel *message = self.dataSource[indexPath.row];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(message.toUserIcon)] 
                       placeholderImage:kDEFAULT_HEAD_IMAGE];
    cell.namelabel.text = message.toUserName;
    switch (message.type) {
        case MessageTypeTEXT: 
            cell.typeLabel.text =message.content;
            break;
        case MessageTypePICTURE: 
            cell.typeLabel.text =message.isFromSelf?@"[Photo]":@"[You have received a photo]";
            break;
        case MessageTypeVOICE: 
            cell.typeLabel.text =@"[You have received a voice]";
            break;
        case MessageTypeVIDEO: 
            cell.typeLabel.text =@"[You have received a video]";
            break;
        default:
            break;
    }
    cell.timeLabel.text = [Util distanceTimeWithBeforeTime:message.timeinterval];
    cell.notificationStatusImageView.hidden = message.isRead;
  
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMessageStatusImage" object:nil];
    
    MessageModel *message = self.dataSource[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *detail = [[ChatViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.toUserName = message.toUserName;
    detail.toUserIcon = message.toUserIcon;
    detail.toUser = message.toUser;
    [self.navigationController pushViewController:detail animated:YES];
    
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

@end

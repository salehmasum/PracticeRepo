//
//  ChatViewController.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "MessageModel.h"
#import "UIViewController+XHPhoto.h"
#import "NotificationHelper.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_dataSource;
    BOOL _viewDidDisappear;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sendView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIView *customerNavigationbar;
@property (weak, nonatomic) IBOutlet UIImageView *navImageView;

@end

@implementation ChatViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_WHITE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:COLOR_BLUE];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"chat-nav-background"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];  
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
   [XMPPService sharedInstance].currentUserMessageBlock = nil;
    _viewDidDisappear = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _viewDidDisappear = NO;
    
}
- (void)viewDidLayoutSubviews{
    
    if (_dataSource.count>2) {
        [self scrollToBottom];
    }
    
  
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [XMPPService sharedInstance].currentUserMessageBlock = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = _toUserName;//@"Message";
    self.title = _toUserName;//@"Message";
    self.textField.enablesReturnKeyAutomatically = YES; 
  //  [self setKeyboardNotificationWith:self.tableView];
    
  //  self.navigationItem.titleView = _titleLabel;
    
     [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCell class]) bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    
    _dataSource = [NSMutableArray array];
    
    _dataSource = [[SQLHelper sharedInstance] selectMessageToUser:self.toUser];
    
    
    for (NSInteger index=0; index<_dataSource.count; index++) {
        MessageModel *message = _dataSource[index];
        NSLog(@"%f=%@",message.timeinterval,[Util distanceTimeWithBeforeTime:message.timeinterval]);
    }
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
     
    
    //聊天页面时获取消息更新页面
    [XMPPService sharedInstance].currentUserMessageBlock = ^BOOL(MessageModel *message) {
        
        if (message.toUser.integerValue == self.toUser.integerValue) {
            [self receiveMessage:message];
            if (_viewDidDisappear) {
                [NotificationHelper registerLocalNotification:message];
            }
            return YES;
        }else{
            return NO;
        }
    } ;
    [self performSelector:@selector(updataUI) withObject:nil afterDelay:0.1];
}

- (void)updataUI{
    self.tableView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-64-iSiPhoneX*24-CGRectGetHeight(self.sendView.frame)-iSiPhoneX*20);
    self.sendView.center = CGPointMake(self.sendView.center.x, CGRectGetMaxY(self.tableView.frame)+CGRectGetHeight(self.sendView.frame)/2.0);
}
 
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.tableView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-64-24*iSiPhoneX-CGRectGetHeight(self.sendView.frame)-keyboardRect.size.height-iSiPhoneX);
    self.sendView.center = CGPointMake(self.sendView.center.x, CGRectGetMaxY(self.tableView.frame)+CGRectGetHeight(self.sendView.frame)/2.0);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度 
    
  //  self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-64-iSiPhoneX*24-CGRectGetHeight(self.sendView.frame)-iSiPhoneX*20);
    self.sendView.center = CGPointMake(self.sendView.center.x, CGRectGetMaxY(self.tableView.frame)+CGRectGetHeight(self.sendView.frame)/2.0);
} 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    
    self.btnSend.enabled = self.textField.text.length;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendText:nil];
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 //   MessageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MessageModel *message = _dataSource[indexPath.row];
    if (message.type == MessageTypePICTURE) {
        return 193;
    }
    return [self getTextHeightWithString:message.content width:213*TX_SCREEN_OFFSET-30];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
//    NSDictionary *message = _dataSource[indexPath.row];
//    cell.lbContent.text = [NSString stringWithFormat:@"H:%@,F:%@",message[@"height"],message[@"isFromSelf"]];
//    cell.isFromSelf = [message[@"isFromSelf"] boolValue];
    MessageModel *cellMessage = _dataSource[indexPath.row];
    cell.message = cellMessage;
    cell.reSendBlock = ^(MessageModel *message) {
        if (message.type == MessageTypeTEXT) {
            [self requestSendTextMessage:message];
        }  else{
            [self requestSendImageMessage:message];
        }
    };
    
    if (cellMessage.type == MessageTypePICTURE) {
        NSLog(@"-----%@",cellMessage.content);
    }
    cell.sendState = cellMessage.messageState;
    cell.lbContent.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.textField resignFirstResponder];
    
    MessageModel *message = _dataSource[indexPath.row];
    if (message.type == MessageTypePICTURE) {
        SKFPreViewNavController *imagePickerVc;
        NSMutableArray *array = [NSMutableArray array];
        if (![message.content containsString:@"/"]) { 
            [array addObject:[UIImage imageWithContentsOfFile:DocumentsFile(message.content)]];
            imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotos:array index:0 DeletePic:NO ];
            
        }else{
            [array addObject:URLStringForPath(message.content)];
            imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:array index:0 ];
        }
       
        
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
    
}
- (CGFloat)getTextHeightWithString:(NSString *)string width:(CGFloat)width{  
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];  
    return  rect.size.height+50*TX_SCREEN_OFFSET;  
}  
// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
} 
#pragma mark - Action

- (IBAction)sendText:(id)sender {
    
    MessageModel *message  = [[MessageModel alloc] init];
    message.type = MessageTypeTEXT;
    message.isFromSelf = YES;
    message.content = self.textField.text;
    
    message.timeinterval = [[NSDate date] timeIntervalSince1970]*1000;
    message.toUser = self.toUser;
    message.toUserIcon = self.toUserIcon;
    message.toUserName = self.toUserName;
    message.user = kUSER_ID;
    message.isRead = YES;
    [self insertMessage:message];
    
    self.textField.text = @"";
    self.btnSend.enabled = NO;
    
    [self requestSendTextMessage:message];
}

- (IBAction)sendImage:(id)sender {
    
    [self.textField resignFirstResponder];
    
    [self showCanEdit:NO photo:^(UIImage *photo) {
        
        NSString*path = [self saveImageDocuments:photo];
        NSLog(@"%@,%@",path,path.lastPathComponent);
        
        MessageModel *message  = [[MessageModel alloc] init];
        message.type = MessageTypePICTURE;
        message.isFromSelf = YES;
        message.content = path.lastPathComponent;
        message.timeinterval = [[NSDate date] timeIntervalSince1970]*1000;
        message.toUser = self.toUser;
        message.toUserIcon = self.toUserIcon;
        message.toUserName = self.toUserName;
        message.user = kUSER_ID;
        message.isRead = YES;
        message.messageState = SendMessageStateLoading;
        [self insertMessage:message];
        
        [self requestSendImageMessage:message];
    }];
}
- (void)requestSendTextMessage:(MessageModel *)message{
    [self sendMessage:message stateAnimation:SendMessageStateLoading]; 
    [ShareCareHttp POST:API_MESSAGE_SEND_TEXT 
          withParaments:@{@"message":message.content,@"toUser":message.toUser,@"shareType":@"SHARECATE"} 
       withSuccessBlock:^(id response) {
           [self sendMessage:message stateAnimation:SendMessageStateSuccess ];
       } withFailureBlock:^(NSString *error) {
           [self sendMessage:message stateAnimation:SendMessageStateFaild];
       }];
}

- (void)requestSendImageMessage:(MessageModel *)message{
    [self sendMessage:message stateAnimation:SendMessageStateLoading]; 
    UIImage *image = [UIImage imageWithContentsOfFile:DocumentsFile(message.content)];
    [ShareCareHttp upload:API_MESSAGE_SEND_IMAGE 
            withParaments:@{@"message":@"png",@"toUser":message.toUser,@"shareType":@"SHARECATE"} 
                   photos:@[image] 
      uploadProgressBlock:^(float progress) {
          
      } withSuccessBlock:^(id response) {
          
          [self sendMessage:message stateAnimation:SendMessageStateSuccess ];
      } withFailureBlock:^(NSString *error) {
          [self sendMessage:message stateAnimation:SendMessageStateFaild];
      }];
}



- (void)insertMessage:(MessageModel *)message{
    [self receiveMessage:message]; 
    [[SQLHelper sharedInstance] addMessage:message];
}

- (void)receiveMessage:(MessageModel *)message{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger row = _dataSource.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [indexPaths addObject: indexPath];
    
    [_dataSource addObject:message];
    [self.tableView reloadData]; 
    
       // [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
      //  [self.tableView endUpdates]; 
    
    [self scrollToBottom];
} 

- (void)sendMessage:(MessageModel *)message stateAnimation:(SendMessageState)state{
    NSInteger row = [_dataSource indexOfObject:message];//_dataSource.count;
    NSLog(@"message----%ld",row);
    message.messageState = state;
    [_dataSource replaceObjectAtIndex:row withObject:message];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    MessageCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.sendState = state;
}

- (void)scrollToBottom
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_dataSource count]-1 inSection:0]
                              atScrollPosition: UITableViewScrollPositionBottom
                                      animated:NO];
}

@end

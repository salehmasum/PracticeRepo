//
//  SettingsTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SettingsTableVC.h"
#import "NotificationsSettingsVC.h"
#import "TermsServiceVC.h"
#import "EventPaymentAndBillingVC.h"
#import "ShareCarePaymentTableVC.h"
#import "AppDelegate.h"
@interface SettingsTableVC (){
    NSMutableArray *_dataSource;
}

@end

@implementation SettingsTableVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"line"]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"settings"];
    self.tableView.tableFooterView = [UIView new];
    //   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSArray *arr = @[@{@"name":CustomLocalizedString(@"Notifications", @"set"),
                      @"icon":@"",
                      @"selector":@"configNotifications:"},
                    @{@"name":CustomLocalizedString(@"Payments Received", @"set"),
                      @"icon":@"",
                      @"selector":@"configPaymentsAndReceived:"},
                    @{@"name":CustomLocalizedString(@"Terms of Service", @"set"),
                      @"icon":@"",
                      @"selector":@"configTermsOrService:"},
                    @{@"name":[NSString stringWithFormat:@"Version %@",kAPPVERSION],
                      @"icon":@"",
                      @"selector":@"configVersion:"},
                    @{@"name":CustomLocalizedString(@"Log Out", @"set"),
                      @"icon":@"",
                      @"selector":@"logout:"}
                    ];
    
    
    _dataSource = [NSMutableArray arrayWithArray:arr];
    
    if (_roleType == UserRoleTypeEvent) {
      //  [_dataSource removeObjectAtIndex:1];
        [_dataSource replaceObjectAtIndex:1 withObject:
         @{@"name":CustomLocalizedString(@"Payment", @"set"),
           @"icon":@"",
           @"selector":@"configPaymentAndBilling:"}];
    }
    
    NSString *userName =kUSER_EMAIL;
    NSString *facebookId =kFACEBOOK_USERID;
    
    if ([userName isEqualToString:@"zhuming@126.com"]||
        [userName isEqualToString:@"koko@gmail.com"]||
        [userName isEqualToString:@"aa@gmail.com"]||
        [userName isEqualToString:@"yy@gmail.com"]||
        [userName isEqualToString:@"lx_java@foxmail.com"]||
        [facebookId isEqualToString:@"928387593981774"]
        ) {
        [_dataSource addObject:@{@"name":CustomLocalizedString(@"打开调试日志", @"set"),
                                 @"icon":@"",
                                 @"selector":@"debug:"}];
    } 

//    if (_roleType == UserRoleTypeEvent) {
//        [_dataSource removeObjectAtIndex:1];
//    }
    
    
    /*
     ,
     @{@"name":CustomLocalizedString(@"Pay TEST", @"set"),
     @"icon":@"",
     @"selector":@"pay:"}
     */
}

- (void)debug:(id)sender{
    
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).openLogResult) {
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).openLog = NO;
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).openLogResult = NO;
        [SVProgressHUD showInfoWithStatus:@"关闭调试日志"];
        return;
    }
    
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).openLog) {
        ((AppDelegate *)([UIApplication sharedApplication].delegate)).openLogResult = YES;
        [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:@"打印网络请求结果"];
        return;
    }
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).openLog = !((AppDelegate *)([UIApplication sharedApplication].delegate)).openLog;
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).textView.text = @"";
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:@"打开日志"];
}


- (void)configPaymentsAndReceived:(id)sender{
    
    ShareCarePaymentTableVC *paymentVC  = [[ShareCarePaymentTableVC alloc] init];
    paymentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paymentVC animated:YES];
    
}
- (void)configPaymentAndBilling:(id)sender{
    EventPaymentAndBillingVC *paymentVC  = [[EventPaymentAndBillingVC alloc] init];
    paymentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paymentVC animated:YES]; 
}

- (void)configNotifications:(id)sender{
    NotificationsSettingsVC *settingVC  = [[NotificationsSettingsVC alloc] init];
    settingVC.title = @"Notifications";
    settingVC.hidesBottomBarWhenPushed = YES;
    settingVC.roleType = self.roleType;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)configTermsOrService:(id)sender{
    TermsServiceVC *settingVC  = [[TermsServiceVC alloc] init]; 
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)configVersion:(id)sender{
//    AudioPlayerHelper *play = [[AudioPlayerHelper alloc] init];
//    [play receiveMessage];
    
    //测试消息
//    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
//    appDelegate.notification = @{@"aps":@{@"alert":@"your police check/working approval failed!"}};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidReceiveStateActiveNotification" object:nil];
    
    
    
 //   [self performSelector:@selector(post) withObject:nil afterDelay:3];
 //   [self test];
}


- (void)test{
    NSDictionary *receive = @{@"userName":@"zhuming",
                              @"booking":@{
                                  @"bookingStatus":@"1",
                                  @"careType":@"2",
                                  @"id":@"250", 
                              },
                              @"id":@"250",
                              
                              };
    NSDictionary *booking = receive[@"booking"];
    NSInteger bookingStatus = [booking[@"bookingStatus"] integerValue];
    if (bookingStatus == 0 || bookingStatus==1) { 
        NSString *title;
        NSString *message; 
        if (bookingStatus == 0) {
            title = [NSString stringWithFormat:@"Congratulations! You have a new booking."];
            message = [NSString stringWithFormat:@"%@ has booked your %@ service. Please respond.",receive[@"userName"],[booking[@"careType"] integerValue]==1?@"Babysitting":@"EleCare"];
            [self showAlertTitle:title message:message BookingId:[NSString stringWithFormat:@"%@",booking[@"id"]]];
        }else if (bookingStatus ==1 && [booking[@"careType"] integerValue]==2) {
            title = @"Congratulations! ";
            message = [NSString stringWithFormat:@"%@ have confirmed attendance to your event.",receive[@"userName"]];
            [self showAlertTitle:title message:message BookingId:[NSString stringWithFormat:@"%@",booking[@"id"]]];
        }
    } 
}
- (void)showAlertTitle:(NSString *)title
               message:(NSString *)msg
             BookingId:(NSString *)bookingId{
//    UIAlertController *alertController = [UIAlertController 
//                                          alertControllerWithTitle:title
//                                          message:msg
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go Back" 
//                                                           style:UIAlertActionStyleDefault 
//                                                         handler:^(UIAlertAction * _Nonnull action) { 
//                                                         }];
//    [alertController addAction:cancelAction];
//    
//    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Continue" 
//                                                         style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction * _Nonnull action) { 
//                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"queryBookingDetail" object:bookingId];
//                                                       }];
//    [alertController addAction:saveAction];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil]; 
    
    
//    UIAlertController *alertController = [UIAlertController 
//                                          alertControllerWithTitle:@"Oops! Something went wrong! " 
//                                          message:@"Looks like there was an issue processing your Police Check or Working with Children’s check. We’ve sent you an email with instructions on how to proceed." 
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go Back" 
//                                                           style:UIAlertActionStyleDefault 
//                                                         handler:^(UIAlertAction * _Nonnull action) { 
//                                                         }];
//    [alertController addAction:cancelAction];
//    
//    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"View Profile" 
//                                                         style:UIAlertActionStyleDefault
//                                                       handler:^(UIAlertAction * _Nonnull action) { 
//                                                           
//                                                           
//                                                       }];
//    [alertController addAction:saveAction];
//    [self presentViewController:alertController animated:YES completion:^{ 
//    }];
}

- (void)post{
    
    
    
    
    /*
              ios8以上版本需要在appdelegate中注册申请权限 本地通知在软件杀死状态也可以接收到消息
              */
    // 1.创建本地通知
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    // 2.设置本地通知(发送的时间和内容是必须设置的)
    localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:3.0];
    localNote.alertBody = @"You have received a message.";
    
    /**
     其他属性: timeZone 时区
     repeatInterval 多长时间重复一次:一年,一个世纪,一天..
     region 区域 : 传入中心点和半径就可以设置一个区域 (如果进入这个区域或者出来这个区域就发出一个通知)
     regionTriggersOnce  BOOL 默认为YES, 如果进入这个区域或者出来这个区域 只会发出 一次 通知,以后就不发送了
     alertAction: 设置锁屏状态下本地通知下面的 滑动来 ...字样  默认为滑动来查看
     hasAction: alertAction的属性是否生效
     alertLaunchImage: 点击通知进入app的过程中显示图片,随便写,如果设置了(不管设置的是什么),都会加载app默认的启动图
     alertTitle: 以前项目名称所在的位置的文字: 不设置显示项目名称, 在通知内容上方
     soundName: 有通知时的音效 UILocalNotificationDefaultSoundName默认声音
     可以更改这个声音: 只要将音效导入到工程中,localNote.soundName = @"nihao.waw"
     */
    
  //  localNote.alertAction = @"You have received a message."; // 锁屏状态下显示: 滑动来快点啊
    //    localNote.alertLaunchImage = @"123";
    localNote.alertTitle = @"You have received a message.";
    localNote.soundName = UILocalNotificationDefaultSoundName;
    localNote.soundName = @"nihao.waw";
    
    /* 这里接到本地通知,badge变为5, 如果打开app,消除掉badge, 则在appdelegate中实现
     [application setApplicationIconBadgeNumber:0];
     */
    localNote.applicationIconBadgeNumber = 5;
    
    // 设置额外信息,appdelegate中收到通知,可以根据不同的通知的额外信息确定跳转到不同的界面
    /*
     {@"accountId":@"14",@"userIcon":@"static/images/14/profile/20171208151704/20171208151703712.png",@"userName":@"朱明",@"message":"21",@"type":@"0",@"imageIcon":@"static/images/14/profile/20171208151704/20171208151703712.png",@"audio":@"",@"sendTime":@"1514525332800"}

     */
    localNote.userInfo = @{@"accountId":@"14",@"userIcon":@"static/images/14/profile/20171208151704/20171208151703712.png",@"userName":@"朱明",@"message":@"21",@"type":@"4",@"imageIcon":@"static/images/14/profile/20171208151704/20171208151703712.png",@"audio":@"",@"sendTime":@"1514525332800"};
    
    // 3.调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
}

- (void)logout:(id)sender{
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:CustomLocalizedString(@"Are you sure you want to Log Out of EleCare?", @"setting") 
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go Back", @"setting") 
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                           }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Log Out", @"setting") 
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                           [weakSelf requestLogOut];
                                                       }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)requestLogOut{ 
    
//    USERDEFAULT_SET_LOGIN(LoginStateNO);
//    [XMPPService disConnection];
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Main"];
//    return;
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    
 //   NSString *api = [NSString stringWithFormat:@"%@token=%@",API_LOGOUT,kUSER_TOKEN];
    [ShareCareHttp GET:API_LOGOUT withParaments:@[kUSER_TOKEN] withSuccessBlock:^(id response) { 
        
        USERDEFAULT_SET(@"token", @"");
        USERDEFAULT_SET_LOGIN(LoginStateNO);
        [XMPPService disConnection];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Main"];
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89*TX_SCREEN_OFFSET;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settings" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.textColor = TX_RGB(136, 136, 136);
    cell.textLabel.font = TX_FONT(20);
    cell.indentationLevel = 1;
    cell.textLabel.text = _dataSource[indexPath.row][@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SEL selector = NSSelectorFromString(_dataSource[indexPath.row][@"selector"]); 
    if ([self respondsToSelector:selector]) { 
        [self performSelector:selector withObject:nil];
    }
} 





@end


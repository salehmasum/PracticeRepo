//
//  XMPPService.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "XMPPService.h"

@implementation XMPPService
static XMPPService *sharedService;  
+ (XMPPService *)sharedInstance{  
    
    static dispatch_once_t onceToken;  
    dispatch_once(&onceToken, ^{  
        sharedService = [[XMPPService alloc]init];  
    });  
    return sharedService;  
}  
+ (BOOL)connectXMPP{
    return [[XMPPService sharedInstance] connect];
}

+ (void)disConnection{
    [[XMPPService sharedInstance] disconnect];
}
- (instancetype)init{
    if (self = [super init]) {
        if (!xmppStream) {
            xmppStream = [[XMPPStream alloc]init];  
            [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()]; 
        }
        
        if (!xmppReconnect) {
            xmppReconnect = [[XMPPReconnect alloc] init];  
            [xmppReconnect activate:xmppStream];  
        }
        
        if (!xmppRosterStorage) {
            xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];  
        }
        if (!xmppRoster) {
            xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];  
            [xmppRoster activate:xmppStream];  
            [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()]; 
        }
        return self;
    }
    return nil;
} 

- (BOOL)connect{
    if (![xmppStream isDisconnected]) {  
        
//        if (self.isXmppAuthened == NO) {
//            [self authenticatePassword];
//        }
        return YES;  
    }  
    
    NSString *myJID;// = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];  
    NSString *myPassword;// = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];  
    if (kUSER_LOGIN_STATE == LoginStateEmail) {
        myJID = kUSER_ID;
        myPassword = kUSER_PASSWORD;
    }else{
        myJID = kUSER_ID;
        myPassword = FACEBOOK_DEFAULT_LOGIN_PASSWORD;
    }
    
    if (myJID == nil || myPassword == nil) {  
        return NO;  
    }  
    
  //  myJID = @"20";//[NSString stringWithFormat:@"zhuming",@""];
    [xmppStream setMyJID:[XMPPJID jidWithUser:myJID domain:kXMPPDomain resource:@"iOS"]];  
    [xmppStream setHostName:kXMPPHost];  
    [xmppStream setHostPort:kXMPPPort];  
    password=myPassword;  
    
    
    NSLog(@"XMPP:%@,%@",myJID,password);
    
    NSError *error ;  //XMPPStreamTimeoutNone
    if (![xmppStream connectWithTimeout:30 error:&error]) {  
        NSLog(@"my connected error : %@",error.description);  
        return NO;  
    }  
    
    return YES;  
}  

- (void)authenticatePassword{
    NSError *error ;  
    if (![xmppStream authenticateWithPassword:password error:&error]) {  
        NSLog(@"error authenticate : %@",error.description);  
    } 
}
#pragma mark - XMPPStreamDelegate  
//连接  
- (void)xmppStreamWillConnect:(XMPPStream *)sender  
{  
    NSLog(@"xmppStreamWillConnect");  
}  
- (void)xmppStreamDidConnect:(XMPPStream *)sender  
{  
    NSLog(@"开始连接服务器的时候：xmppStreamDidConnect");  
    self.isXmppConnected = YES;  
    [self authenticatePassword];
}  
//验证  
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender  
{  
    self.isXmppAuthened = YES;
    NSLog(@"验证成功：xmppStreamDidAuthenticate");  
    [self goOnline];  
}  
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error  
{  
    self.isXmppAuthened = NO;
    NSLog(@"验证失败：didNotAuthenticate:%@",error.description);  
}  

- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource  
{  
    NSLog(@"alternativeResourceForConflictingResource: %@",conflictingResource);  
    return @"XMPPIOS";  
}  

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq  
{  
    NSLog(@"didReceiveIQ: %@",iq.description);  
    return YES;  
}  
//上线
- (void)goOnline  
{  
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [xmppStream sendElement:presence];  
} 
//退出并断开连接
- (void)disconnect {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [xmppStream sendElement:presence];
    
    [xmppStream disconnect];
}
//接受到好友状态更新  
//接收添加好友信息 available 上线 away 离开 do not disturb 忙碌 unavailable 下线  
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence  
{  
    NSLog(@"好友状态更新：didReceivePresence: %@",presence.description);  
}  
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error  
{  
    NSLog(@"didReceiveError: %@",error.description);  
}  
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq  
{  
    NSLog(@"didSendIQ:%@",iq.description);  
}  
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence  
{  
    NSLog(@"didSendPresence:%@",presence.description);  
}  
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error  
{  
    NSLog(@"didFailToSendIQ:%@",error.description);  
}  
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error  
{  
    NSLog(@"didFailToSendMessage:%@",error.description);  
    NSLog(@"发送失败，麻烦检查下网络");  
}  
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error  
{  
    NSLog(@"didFailToSendPresence:%@",error.description);  
}  
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender  
{  
    NSLog(@"xmppStreamWasToldToDisconnect");  
}  
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender  
{  
    NSLog(@"xmppStreamConnectDidTimeout");  
}  
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error  
{  
    NSLog(@"连接断开的时候：xmppStreamDidDisconnect: %@",error.description);  
    self.isXmppConnected = NO;  
}  


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSString *messageBody = [[message elementForName:@"body"] stringValue];
    NSLog(@"收到消息：%@,%@",messageBody,message.type);
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).openLogResult) {
        
        [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:[NSString stringWithFormat:@"收到消息：%@,%@",messageBody,message.type]];
    }
    
    NSData *data = [messageBody dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *receive = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    MessageType type = (MessageType)[receive[@"type"] integerValue];
    
    MessageModel *model  = [[MessageModel alloc] init];
    model.timeinterval = [receive[@"sendTime"] longLongValue];
    model.toUser = receive[@"accountId"];
    model.toUserIcon = receive[@"userIcon"];
    model.toUserName = receive[@"userName"];
    model.user = kUSER_ID;
    model.isRead = NO;
    model.type = type;
    model.isFromSelf = NO;
    switch (type) {
        case MessageTypeTEXT:
            model.content = receive[@"message"];
            break;
        case MessageTypePICTURE:
            model.content = receive[@"imageIcon"];
            break;
        case MessageTypeVOICE:
        case MessageTypeVIDEO:
            model.content = receive[@"audio"];
            break;
        case MessageTypeBOOKING:{
            NSDictionary *bookinginfo = receive[@"booking"];
            model.isNotification= YES;
            model.toUser = bookinginfo[@"id"];//订单相关以某个订单为集合
            model.content = [NSString stringWithFormat:@"%@!*#%@!*#%@!*#%@!*#%@",
                             receive[@"message"],
                             bookinginfo[@"id"],
                             bookinginfo[@"bookingStatus"],
                             bookinginfo[@"careType"],
                             bookinginfo[@"pubAccountId"]];
        }
            break;
        default:
            model.content = receive[@"message"];
            break;
    }
    
    
    
    
    if (_currentUserMessageBlock && _currentUserMessageBlock(model)) {
        model.isRead = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMessageStatusImage" object:nil];
    }else{ 
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showMessageStatusImage" object:nil];
    }
    [[SQLHelper sharedInstance] addMessage:model];
    
    
    if (_inboxMessageBlock) {
        _inboxMessageBlock(model);
    }
    if (_inboxNotificationBlock) {
        _inboxNotificationBlock(model);
    }
    
    if ((model.isRead==NO && !_inboxMessageBlock) && type!=MessageTypeBOOKING) {
        [NotificationHelper registerLocalNotification:model];
    }
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateActive && type==MessageTypeBOOKING)  {
        
        NSDictionary *booking = receive[@"booking"];
        NSInteger bookingStatus = [booking[@"bookingStatus"] integerValue];
        if (bookingStatus == 0 || bookingStatus==1) { 
            NSString *title;
            NSString *message; 
            if (bookingStatus == 0) {
                title = [NSString stringWithFormat:@"Congratulations! You have a new booking."];
                message = [NSString stringWithFormat:@"%@ has booked your %@ service. Please respond.",receive[@"userName"],[booking[@"careType"] integerValue]==1?@"Babysitting":@"EleCare"];
                [self showAlertTitle:title 
                             message:message 
                           BookingId:[NSString stringWithFormat:@"%@",booking[@"id"]]
                        pubAccountId:[NSString stringWithFormat:@"%@",booking[@"pubAccountId"]]];
            }else if (bookingStatus ==1 && [booking[@"careType"] integerValue]==2) {
                title = @"Congratulations! ";
                message = [NSString stringWithFormat:@"%@ have confirmed attendance to your event.",receive[@"userName"]];
                [self showAlertTitle:title 
                             message:message 
                           BookingId:[NSString stringWithFormat:@"%@",booking[@"id"]]
                        pubAccountId:[NSString stringWithFormat:@"%@",booking[@"pubAccountId"]]];
            }else{
                [NotificationHelper registerLocalNotification:model];
            }  
            
        }else{
            [NotificationHelper registerLocalNotification:model];
        }
    }
}
- (void)showAlertTitle:(NSString *)title
               message:(NSString *)msg
             BookingId:(NSString *)bookingId
          pubAccountId:(NSString *)pubAccountId{
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:title
                                          message:msg
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go Back" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:^(UIAlertAction * _Nonnull action) { 
                                                         }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Continue" 
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) { 
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:@"queryBookingDetail" 
                                                                                                               object:@{@"bookingId":bookingId,
                                                                                                                        @"pubAccountId":pubAccountId}
                                                            ];
                                                       }];
    [alertController addAction:saveAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil]; 
}
@end

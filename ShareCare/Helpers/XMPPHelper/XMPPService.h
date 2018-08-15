//
//  XMPPService.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>
#import "MessageModel.h"

typedef void(^ReceiveInboxMessageBlock)(MessageModel *message);
typedef void(^ReceiveInboxNotificationBlock)(MessageModel *message);
typedef BOOL(^ReceiveCurrentChatUserMessageBlock)(MessageModel *message);

@interface XMPPService : NSObject<XMPPStreamDelegate>{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPRoster *xmppRoster;
    
    NSString *password;
}

@property (assign, nonatomic) BOOL isXmppConnected;
@property (assign, nonatomic) BOOL isXmppAuthened;
+ (XMPPService *)sharedInstance;
+ (BOOL)connectXMPP;
+ (void)disConnection;

@property (strong, nonatomic) ReceiveInboxMessageBlock inboxMessageBlock;
@property (strong, nonatomic) ReceiveInboxNotificationBlock inboxNotificationBlock;
@property (strong, nonatomic) ReceiveCurrentChatUserMessageBlock currentUserMessageBlock;

- (void)sendMessage:(NSString *) message toUser:(NSString *) user;
@end

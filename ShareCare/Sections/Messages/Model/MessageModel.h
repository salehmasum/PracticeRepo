//
//  MessageModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"
#import "BookingModel.h"

typedef enum : NSUInteger {
    MessageTypeTEXT     =0,
    MessageTypePICTURE  =1,
    MessageTypeVOICE    =2,
    MessageTypeVIDEO    =3,
    MessageTypeBOOKING  =4,
    MessageTypeCertificateAuditFaild =5,
    MessageTypeCertificateAuditSuccess  =6
} MessageType;
typedef enum : NSUInteger {
    SendMessageStateLoading,
    SendMessageStateSuccess,
    SendMessageStateFaild
} SendMessageState;

@interface MessageModel : BaseModel
@property (assign, nonatomic) NSInteger number;      //自增序号
@property (copy, nonatomic)   NSString *user;        //自己
@property (copy, nonatomic)   NSString *toUser;      //接收者id
@property (copy, nonatomic)   NSString *toUserName;  //接收者名字
@property (copy, nonatomic)   NSString *toUserIcon;  //接收者
@property (assign, nonatomic) MessageType type;      //消息类型
@property (assign, nonatomic) BOOL isFromSelf;       //是否为自己发的
@property (copy, nonatomic)   NSString *content;     //内容，消息类型为图片、音频、视频时为文件地址
@property (assign, nonatomic) NSTimeInterval timeinterval;//时间
@property (assign, nonatomic) BOOL isNotification;       //是否为推送通知
@property (assign, nonatomic) BOOL isRead;       //是否为推送通知
@property (assign, nonatomic) SendMessageState messageState;       //是否发送成功


@property (copy, nonatomic)   NSString *sessionId;      //
@property (copy, nonatomic)   BookingModel *booking;      //

@end

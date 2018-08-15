//
//  MessageCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"


typedef void(^SendMessageFaildBlock)(MessageModel *message);
@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *msgImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (assign, nonatomic) BOOL isFromSelf;
@property (assign, nonatomic) SendMessageState sendState;
@property (strong, nonatomic) MessageModel *message;
@property (strong, nonatomic) SendMessageFaildBlock reSendBlock;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *btnResend;
- (IBAction)reSend:(id)sender;
@end

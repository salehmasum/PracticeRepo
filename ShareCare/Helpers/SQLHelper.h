//
//  SQLHelper.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
 
@interface SQLHelper : NSObject

+ (SQLHelper *)sharedInstance;
- (void)openSqlite;
- (void)createMessageTable;
- (void)closeSqlite;
- (NSMutableArray *)selectAllMessage;
- (NSMutableArray *)selectMessageToUser:(NSString *)toUser;
- (void)addMessage:(MessageModel *)message;
- (void)deleteToUser:(NSString *)toUser ;
- (void)updataMessage:(MessageModel *)message;
- (NSMutableArray *)selectMessageList;
- (NSMutableArray *)selectNotificationList;
@end

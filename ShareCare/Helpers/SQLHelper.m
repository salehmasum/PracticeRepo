//
//  SQLHelper.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SQLHelper.h"
#import <sqlite3.h>

static sqlite3 *db=nil;//是指向数据库的指针,我们其他操作都是用这个指针来完成
static SQLHelper *sharedService;  
@implementation SQLHelper

+ (SQLHelper *)sharedInstance{  
    static dispatch_once_t onceToken;  
    dispatch_once(&onceToken, ^{  
        sharedService = [[SQLHelper alloc]init];  
    });  
    return sharedService;  
} 

- (void)openSqlite {
    //判断数据库是否为空,如果不为空说明已经打开
    if(db != nil) {
        NSLog(@"数据库已经打开");
        return;
    }
    
    //获取文件路径
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *strPath = [str stringByAppendingPathComponent:@"Inbox.sqlite"];
    NSLog(@"%@",strPath);
    //打开数据库
    //如果数据库存在就打开,如果不存在就创建一个再打开
    int result = sqlite3_open([strPath UTF8String], &db);
    //判断
    if (result == SQLITE_OK) {
        NSLog(@"数据库打开成功");
        [self createMessageTable];
    } else {
        NSLog(@"数据库打开失败");
    }
}

#pragma mark - 3.增删改查
//创建表格
- (void)createMessageTable {
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"create table if not exists 'MessageModel' (\
                        'number' integer primary key autoincrement not null,\
                        'user' text,\
                        'toUser' text,\
                        'toUserName' text,\
                        'toUserIcon' text,\
                        'type' integer,\
                        'isFromSelf' integer,\
                        'content' text,\
                        'timeinterval' double,\
                        'isNotification' integer,\
                        'isRead' integer)\
                        "];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    //3.sqlite语句是否执行成功
    
    if (result == SQLITE_OK) {
        NSLog(@"创建表成功");
    } else {
        NSLog(@"创建表失败");
    }
}

//添加数据
- (void)addMessage:(MessageModel *)message {
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"insert into MessageModel(user,toUser,toUserName,toUserIcon,type,isFromSelf,content,timeinterval,isNotification,isRead) values ('%@','%@','%@','%@','%ld','%d','%@','%f','%d','%d')",message.user,message.toUser,message.toUserName,message.toUserIcon,message.type,message.isFromSelf,message.content,message.timeinterval,message.isNotification,message.isRead];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"添加数据成功");
    } else {
        NSLog(@"添加数据失败");
    }
}
//删除数据
- (void)deleteToUser:(NSString *)toUser {
    //1.准备sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"delete from MessageModel where toUser = '%@' and user ='%@'",toUser,kUSER_ID];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败%s",error);
    }
}

//修改数据
- (void)updataMessage:(MessageModel *)message {
    //1.sqlite语句
    NSString *sqlite = [NSString stringWithFormat:@"update MessageModel set isRead = '%d' where number = '%ld'",message.isRead,message.number];
    //2.执行sqlite语句
    char *error = NULL;//执行sqlite语句失败的时候,会把失败的原因存储到里面
    int result = sqlite3_exec(db, [sqlite UTF8String], nil, nil, &error);
    if (result == SQLITE_OK) {
        NSLog(@"修改数据成功");
    } else {
        NSLog(@"修改数据失败");
    }
}


//每个对话取最新一条
- (NSMutableArray *)selectMessageList{
    NSString *sqlite = [NSString stringWithFormat:@"select *from (select * from (select * from MessageModel where isNotification=0) t group by t.toUser)  where user='%@' order by timeinterval DESC",kUSER_ID];
    return [self selectWithSQLStr:sqlite];
}
- (NSMutableArray *)selectNotificationList{
    NSString *sqlite = [NSString stringWithFormat:@"select *from (select * from (select * from MessageModel where isNotification=1) t group by t.toUser)  where user='%@' order by timeinterval DESC",kUSER_ID];
    return [self selectWithSQLStr:sqlite];
}

- (NSMutableArray *)selectAllNotification{
    NSString *sqlite = [NSString stringWithFormat:@"select * from MessageModel where user ='%@' and isNotification =1",kUSER_ID];
    return [self selectWithSQLStr:sqlite];
}
- (NSMutableArray *)selectAllMessage{
    
//    NSString *sqlite = [NSString stringWithFormat:@"select * from MessageModel"];
    NSString *sqlite = [NSString stringWithFormat:@"select * from MessageModel where user ='%@' and isNotification =0",kUSER_ID];
    return [self selectWithSQLStr:sqlite];
}
- (NSMutableArray *)selectMessageToUser:(NSString *)toUser{
    NSString *sqlite = [NSString stringWithFormat:@"select * from MessageModel where toUser ='%@' and user ='%@' and isNotification =0",toUser,kUSER_ID];
    return [self selectWithSQLStr:sqlite];
}
//查询所有数据
- (NSMutableArray*)selectWithSQLStr:(NSString *)sqlite{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //1.准备sqlite语句
 //   NSString *sqlite = [NSString stringWithFormat:@"select * from MessageModel"];
    //2.伴随指针
    sqlite3_stmt *stmt = NULL;
    //3.预执行sqlite语句
    int result = sqlite3_prepare(db, sqlite.UTF8String, -1, &stmt, NULL);//第4个参数是一次性返回所有的参数,就用-1
    if (result == SQLITE_OK) {
        NSLog(@"查询成功");
        //4.执行n次
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            MessageModel *message = [[MessageModel alloc] init];
            message.number = sqlite3_column_int(stmt, 0);
            message.user = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)] ;
            message.toUser = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)] ;
            message.toUserName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)] ;
            message.toUserIcon = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)] ;
            message.type = sqlite3_column_int(stmt, 5);
            message.isFromSelf = sqlite3_column_int(stmt, 6);
            message.content = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)] ;
            message.timeinterval = sqlite3_column_double(stmt, 8);
            message.isNotification = sqlite3_column_int(stmt, 9);
            message.isRead = sqlite3_column_int(stmt, 10);
            
            [array addObject:message];
        }
    } else {
        NSLog(@"查询失败");
    }
    //5.关闭伴随指针
    sqlite3_finalize(stmt);
    return array;
}

#pragma mark - 4.关闭数据库
- (void)closeSqlite {
    
    if (db) {
        int result = sqlite3_close(db);
        if (result == SQLITE_OK) {
            NSLog(@"数据库关闭成功");
            db = nil;
        } else {
            NSLog(@"数据库关闭失败");
        }
    }
}
@end

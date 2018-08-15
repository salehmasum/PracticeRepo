//
//  ShareCareHttp.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginHttp.h"
#import "AppDelegate.h"
#define CONTENT_TYPE_JSON @"application/json"
#define CONTENT_TYPE_FORMDATA @"multipart/form-data"
//@"multipart/form-data"
typedef enum : NSUInteger {
    HTTPMethodGET,
    HTTPMethodPOST
} HTTPMethod;

/**定义请求成功的block*/
typedef void(^requestSuccess)( id response);

/**定义请求失败的block*/
typedef void(^requestFailure)( NSString *error);

/**定义上传进度block*/
typedef void(^uploadProgress)(float progress);

/**定义下载进度block*/
typedef void(^downloadProgress)(float progress);

@interface ShareCareHttp : NSObject 
@property (strong, nonatomic) NSString *contentType;

+ (NSString *)fileName; 


+(void)requestHTTPMethod:(HTTPMethod)method API:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock;

+(void)GET:(NSString *)urlString withParaments:(NSArray *)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock;

+(void)POST:(NSString *)urlString withParaments:(NSDictionary *)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock;

+(void)upload:(NSString *)urlString withParaments:(NSDictionary *)paraments 
       photos:(NSArray *)photos uploadProgressBlock:(uploadProgress)progressBlock withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock;


+(void)cancelAllRequest;

@end

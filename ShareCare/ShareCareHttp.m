//
//  ShareCareHttp.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareCareHttp.h"

@interface ShareCareHttp(){
    
}

@end
 
@implementation ShareCareHttp 
static BOOL _isCanceled;
static ShareCareHttp *_instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    // 也可以使用一次性代码
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
        }
    });
    return _instance;
     
}
+(instancetype)shareInstance
{ 
    static dispatch_once_t onceToken;   
    dispatch_once(&onceToken, ^{   
        _instance = [[self alloc] init]; 
    });   
    return _instance;   
}
- (instancetype)init{
    if (self = [super init]) {
        _contentType = @"application/json";
        return self;
    }
    return nil;
}
// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}
 
+ (AFHTTPSessionManager *)managerForType:(NSString *)type timeoutInterval:(NSInteger)timeoutInterval{ 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager]; 
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];   
    [requestSerializer setValue:kUSER_TOKEN forHTTPHeaderField:@"token"]; 
    [requestSerializer setValue:type forHTTPHeaderField:@"Content-Type"]; 
    
    NSLog(@"*********************************(%@)",kUSER_TOKEN);
    
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",  
                                                         @"text/html",  
                                                         @"image/jpeg",  
                                                         @"image/png",  
                                                         @"application/octet-stream",  
                                                         @"text/json",  
                                                         nil];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"]; 
     
    return manager;
}


+(void)cancelAllRequest{
    _isCanceled = YES;
    [ [AFHTTPSessionManager manager].operationQueue cancelAllOperations];
}



+(void)requestHTTPMethod:(HTTPMethod)method API:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    if (method == HTTPMethodGET) {
        [self GET:urlString withParaments:paraments withSuccessBlock:successBlock withFailureBlock:failureBlock];
    }else{
        [self POST:urlString withParaments:paraments withSuccessBlock:successBlock withFailureBlock:failureBlock];
    }
}
 
+(void)GET:(NSString *)urlString withParaments:(NSArray *)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{ 
    _isCanceled = NO;
    __weak typeof(self) weakSelf = self;
     urlString =  [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:[NSString stringWithFormat:@"GET:%@,%@",urlString,paraments]];
    
    if (paraments || paraments.count>0) {
        urlString = [NSString stringWithFormat:@"%@%@",URLString(urlString),[paraments componentsJoinedByString:@"/"]];
    }else{
        urlString = URLString(urlString);
    }
    NSLog(@"GET:%@,%@",urlString,paraments);
      
    [[self managerForType:CONTENT_TYPE_JSON timeoutInterval:15] GET:urlString 
      parameters:nil 
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
            [weakSelf handleResponse:responseObject 
                    withSuccessBlock:successBlock 
                    withFailureBlock:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { 
               
            [weakSelf handleError:error task:task withSuccessBlock:successBlock withFailureBlock:failureBlock]; 
            
        }];
    
    
}
+(void)POST:(NSString *)urlString withParaments:(NSDictionary *)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
     
    _isCanceled = NO;
    urlString =  [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak typeof(self) weakSelf = self;
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:[NSString stringWithFormat:@"POST:%@\n%@",urlString,paraments]];
    urlString = URLString(urlString);
    NSLog(@"POST:%@,%@",urlString,paraments);  
    [[self managerForType:CONTENT_TYPE_JSON timeoutInterval:15] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
        [weakSelf handleResponse:responseObject withSuccessBlock:successBlock withFailureBlock:failureBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { 
        [weakSelf handleError:error task:task withSuccessBlock:successBlock withFailureBlock:failureBlock]; 
    }]; 
    
} 


+(void)upload:(NSString *)urlString withParaments:(NSDictionary *)paraments 
       photos:(NSArray *)photos uploadProgressBlock:(uploadProgress)progressBlock withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{ 
    _isCanceled = NO;
    [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:[NSString stringWithFormat:@"upload:%@,%@",urlString,paraments]];
    urlString = URLString(urlString);
    NSLog(@"upload:%@,%@",urlString,paraments);  
    __weak typeof(self) weakSelf = self;  
     
    [[self managerForType:CONTENT_TYPE_FORMDATA timeoutInterval:60] POST:urlString parameters:paraments constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) { 
        for (NSInteger index=0; index<photos.count; index++) {
            UIImage *image = photos[index];
            NSData *data = UIImagePNGRepresentation(image); 
            [formData appendPartWithFileData:data 
                                        name:@"file" 
                                    fileName:[Util fileName] 
                                    mimeType:@"image/jpg"];
        }
         
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if(!_isCanceled) progressBlock(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(!_isCanceled) successBlock(responseObject[@"data"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleError:error task:task withSuccessBlock:successBlock withFailureBlock:failureBlock]; 
    }]; 
} 

+ (void)handleResponse:(id)responseObject withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    if (((AppDelegate *)([UIApplication sharedApplication].delegate)).openLogResult) {
        
        [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:[NSString stringWithFormat:@"success:%@",responseObject]];
    }
    
    if (_isCanceled) return;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[responseObject allKeys] containsObject:@"code"]) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 200) {
                NSLog(@"%@",responseObject[@"data"]);
                
                if ([[responseObject allKeys] containsObject:@"data"]) {
                    
                    id data = [self changeType:responseObject[@"data"]];
                    successBlock(data);
                    
                }else{
                    successBlock(nil);
                }
            }else{
                failureBlock(responseObject[@"message"]);
            }
        }else{
            successBlock(responseObject);
        }
    }else{
        failureBlock(@"request error");
    }
}

+ (void)handleError:(NSError *)error task:(NSURLSessionDataTask*)task withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock{
    
    if (_isCanceled) return;
    NSLog(@"error:%@",error);
    
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (!data) {
        failureBlock(error.localizedDescription);
    }else{
        NSError *err;
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&err];
        
        if(err)
        {
            failureBlock(error.localizedDescription);
        }else{ 
            
            if (((AppDelegate *)([UIApplication sharedApplication].delegate)).openLogResult) {
                
                [((AppDelegate *)([UIApplication sharedApplication].delegate)) print:[NSString stringWithFormat:@"success:%@",responseObject]];
            }
            
            NSInteger code= [responseObject[@"code"] integerValue];
            NSString *message = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
            //code:500,user don't login
            NSLog(@"code=%ld  message=%@",code,message);
            if (code == 500 && [message isEqualToString:@"User doesn't login"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidNotLoginNotification" object:task];
                return;
            }
            
            if ([[responseObject allKeys] containsObject:@"message"]) { 
                
                failureBlock (responseObject[@"message"]);
            }else if ([[responseObject allKeys] containsObject:@"data"]) {
                failureBlock (responseObject[@"data"]);
            }else{
                failureBlock (@"Request faild!");
            }
        }
        
    } 
} 
+ (id)changeType:(id)myObj{
    //判断obj的类型
    if ([myObj isKindOfClass:[NSDictionary class]]){
        return [self nullDic:myObj];
    }else if([myObj isKindOfClass:[NSArray class]]){
        return [self nullArr:myObj];
    }else if([myObj isKindOfClass:[NSString class]]){
        return [self stringToString:myObj];
    }else if([myObj isKindOfClass:[NSNull class]]){
        return [self nullToString];
    }else{
        return myObj;
    }
}
//处理字典类型
+ (NSDictionary *)nullDic:(NSDictionary *)myDic{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++){
        id obj = [myDic objectForKey:keyArr[i]];
        obj = [self changeType:obj];
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}
//处理数组类型
+ (NSArray *)nullArr:(NSArray *)myArr{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++){
        id obj = myArr[i];
        obj = [self changeType:obj];
        [resArr addObject:obj];
    }
    return resArr;
}

+ (NSString *)stringToString:(NSString *)string{
    return string;
}

//将Null类型的项目转化成@""
+ (NSString *)nullToString{
    return @"";
}
@end


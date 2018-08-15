//
//  API.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#ifndef API_h
#define API_h



//#ifndef DEBUG
//#define SERVICE @"39.106.48.129:8080" //测试服务器
//#else 
//#define SERVICE @"13.54.249.248:8080"  //正式服务器
//#endif


#define SERVICE_SANDBOX @"39.106.48.129:8080"
//#define SERVICE_PRODUCT @"13.54.249.248:8080"
#define SERVICE_PRODUCT @"52.63.159.254:8080"



#define SERVICE USERDEFAULT(@"serviceIP")
 
#define URLString(api) [NSString stringWithFormat:@"http://%@%@",SERVICE,api] 
#define URLStringForPath(path) path?([path containsString:@"http"]?path:[NSString stringWithFormat:@"http://%@/%@",SERVICE,path]):@""
 
//#define URLForPath(path) [NSURL URLWithString:URLStringForPath(model.imagePath.firstObject)]

#define PAGEABLE_STRINGFORMAT(pageNumber) [NSString stringWithFormat:@"page=%ld&size=%d",pageNumber,kPageSize]
//#define PAGEABLE_STRINGFORMAT(pageNumber,pageSize) [NSString stringWithFormat:@"pageNumber=%ld&pageSize=%d",pageNumber,pageSize]
#define kURL_CHILDREN_CHECK @"http://www.workingwithchildren.vic.gov.au/home/applications/apply+for+a+check/apply+in+victoria"
#define kURL_POLICE_CHECK @"https://www.nationalcrimecheck.com.au/consumer/start_form"
 

//分页大小控制 
#define kPageSize 15
 
/*-----account------------------------------------------------------*/
#define API_LOGIN    @"/v1/user/api/accounts/login" //0表示 平台 1facebook 2twitter 3instagram
#define API_REGISTER @"/v1/user/api/accounts/register"
#define API_LOGOUT   @"/v1/user/api/accounts/logout/"
#define API_FORGOT_PASSWORD @"/v1/user/api/accounts/forget?"
#define API_USER @"/v1/user/api/accounts/user/" 
#define API_USER_UPDATE @"/v1/user/api/accounts/user/update/" 
//profile上传个人图片
#define API_UPDATE_USER_ICON @"/v1/user/api/accounts/upload/user/icon" 
//profile上传证书
#define API_UPDATE_CERTIFICATE @"/v1/user/api/accounts/upload/certificate" 
//获取个人详细信息，最新接口
#define API_GET_USERINFO @"/v1/user/api/accounts/userInfo/"  
//修改个人详细信息，最新接口
#define API_UPDATE_USERINFO @"/v1/user/api/accounts/update/userinfo"  
//修改小孩接口
#define API_UPDATE_CHILDINFO @"/v1/user/api/accounts/update/childInfo"  

//更新小孩图片
#define API_UPDATE_CHILD_ICON @"/v1/user/api/accounts/upload/child/icon" 

/*-----Create or list------------------------------------------------------*/

//创建之前检查证书是否认证
#define API_VERIFY_CHILDREN_LICENSE @"/v1/favorite/babysitting/list?" 

#define API_SHARECARE_SAVE @"/v1/sharecare/save" 
#define API_SHARECARE_LIST @"/v1/sharecare/list/pageable?"  

#define API_BABYSITTING_SAVE @"/v1/babysitting/save" 
#define API_BABYSITTING_LIST @"/v1/babysitting/list/pageable?"  

#define API_EVENT_SAVE @"/v1/event/save" 
#define API_EVENT_LIST @"/v1/event/list/pageable?" 

/*
 {"locationType":null,"addressLat":null,"addressLon":null,"careType":null,"time":null,conditionEnable:false}
 locationType  0->nearby 1->anywhere 2->location，默认是nearby
 careType  0->share 1->babysitting 2->event
 time，例如：2017-12-04T15:00:00，传0时表示Anytime，tonight：传当天下午18:00:00
 */


//首页查询
//#define API_ALL_NEWEST_LIST @"/v1/sharecare/share/all"
#define API_ALL_NEWEST_LIST @"/v1/sharecare/share/all/pageable?"


/*-----Favorite------------------------------------------------------*/

//POST ftype 0是sharecare 1baby 2event
#define API_SHARECARE_FAVORITE_ADD_OR_REMOVE @"/v1/favorite/addOrRemove" 

//GET
#define API_SHARECARE_FAVORITE_LIST @"/v1/favorite/sharecare/list?"  
#define API_BABYSITTING_FAVORITE_LIST @"/v1/favorite/babysitting/list?" 
#define API_EVENT_FAVORITE_LIST @"/v1/favorite/event/list?" 
#define API_ALL_FAVORITE_LIST @"/v1/favorite/all/list"

//详情
#define API_SHARECARE_DETAIL @"/v1/sharecare/one/"
#define API_BABYSITTING_DETAIL @"/v1/babysitting/one/"
#define API_EVENT_DETAIL @"/v1/event/one/"



 //bookingStatus：pending ->0  confirmed -> 1  rejected -> 2
//照顾类型  0 -> shareCare,  1 -> babySitting, 2 -> event
/*------Booking-----------------------------------------------------*/
//post booking
#define API_BOOKING_APPOINT @"/v1/booking/appoint" 
//get booking
#define API_BOOKING_APPOINT_LIST @"/v1/booking/appoint/list/pageable?" 


#define API_BOOKING_PAST_LIST @"/v1/booking/past/list?"
#define API_BOOKING_UPCOMING_LIST @"/v1/booking/upComing/list?"
//获取订单详情
#define API_BOOKING_DETAIL @"/v1/booking/one/"

#define API_BOOKING_APPOINTED_CHILD @"/v1/booking/appointed/childInfo/"

//POST /v1/booking/reject
#define API_BOOKING_REJECT @"/v1/booking/reject"

//GET /v1/booking/confirm/{bookingId}
#define API_BOOKING_CONFIRM @"/v1/booking/confirm/"
//GET /v1/booking/cancel/{bookingId}
#define API_BOOKING_CANCEL @"/v1/booking/cancel/"


/*--------Pay---------------------------------------------------*/

//POST 支付费用
#define API_PAYMENT_TRANSACTION @"/v1/payment/transaction"
//GET  获取支付的token
#define API_PAYMENT_TOKEN @"/v1/payment/token/"
//GET  根据事物id查询支付详情
#define API_PAYMENT_DETAIL @"/v1/payment/detail"
//GET  根据事物id查询支付详情
#define API_PAYMENT_RECEIPT @"/v1/payment/detail/"

//POST 绑定信用卡
#define API_PAYMENT_CREDITCARD_ADD @"/v1/payment/addCreditCard"
//GET 查找自己的信用卡信息
#define API_PAYMENT_CREDITCARD_LIST @"/v1/payment/creditCard/list"
//GET 解绑信用卡
#define API_PAYMENT_CREDITCARD_DELETE @"/v1/payment/delete/creditCard/"

//POST 绑定银行卡或者paypal
#define API_PAYMENT_ADD_CARD @"/v1/payment/addBankCardOrPaypal"

/*-------Review----------------------------------------------------*/
//POST 
#define API_REVIEW_ADD @"/v1/review/add"
#define API_REVIEW_DETAIL @"/v1/review/detail/"

//GET /v1/review/list/{reviewType}/{reviewTypeId}查看评论列表
#define API_REVIEW_LIST @"/v1/review/list/"

//GET /v1/review/me/reviewOther/{reviewType}
#define API_REVIEW_ME @"/v1/review/others/reviewMe/"

//GET /v1/review/others/reviewMe/{reviewType}我评论的
#define API_REVIEW_OTHER @"/v1/review/me/reviewOther/"

//待评论列表
#define API_BOOKING_PENDING_REVIEW_LIST @"/v1/review/me/pending/review/list/"


/*------Profile-----------------------------------------------------*/

//获取用户booking me的列表GET 
#define API_BOOKING_OTHERS_LIST @"/v1/booking/others/appoint/list/pageable?"


//ShareCare

#define API_SHARECARE_MYSELF_LIST @"/v1/sharecare/myself/list/pageable?"
//Babysitting
#define API_BABYSITTING_MYSELF_LIST @"/v1/babysitting/myself/list/pageable?"

//Event
#define API_EVENT_MYSELF_LIST @"/v1/event/myself/list/pageable?"


/*--------Message---------------------------------------------------*/
//POST图片 /v1/im/image/push
#define API_MESSAGE_SEND_IMAGE @"/v1/im/image/push"
//POST文本 /v1/im/message/push
#define API_MESSAGE_SEND_TEXT @"/v1/im/message/push"
/*-----------------------------------------------------------*/
 
//软件启动后第一个页面
#define WEB_TERMS_AND_CONDITINONS    @"http://news.baidu.com"
#define WEB_PRIVACY_POLICY           @"http://www.baidu.com"
#define WEB_NONDISCRIMINATION_POLICY @"http://www.baidu.com"

//Before you join learn more
#define WEB_BEFORE_YOU_JOIN_LEARN_MORE @"http://www.baidu.com"


/*--------Setting---------------------------------------------------*/

//Notification 
//GET
#define API_MESSAGE_STATUS @"/v1/im/message/status"
//POST
#define API_MESSAGE_SWITCH_STATUS @"/v1/im/message/switch/status"


//POST
#define API_FEEDBACK @"/v1/user/api/accounts/feedback"

//Profile
#define WEB_PROFILE_TERMS_OF_SERVICE                 [NSString stringWithFormat:@"http://%@/html/termsofservice.html",SERVICE]
#define WEB_PROFILE_NONDISCRIMINATION_POLICY         [NSString stringWithFormat:@"http://%@/html/nondiscrimination.html",SERVICE] 
#define WEB_PROFILE_PAYMENTS_TERMS_OF_SERVICE        [NSString stringWithFormat:@"http://%@/html/paymentstermsofservice.html",SERVICE]
#define WEB_PROFILE_PRIVACY_POLICY                   [NSString stringWithFormat:@"http://%@/html/privacypolicy.html",SERVICE]
#define WEB_PROFILE_SHARECARE_OR_BABYSITTINER_POLICY [NSString stringWithFormat:@"http://%@/html/sharepolicy.html",SERVICE]
#define WEB_PROFILE_REFUNDS                          [NSString stringWithFormat:@"http://%@/html/refunds.html",SERVICE]
#define WEB_PROFILE_IP_POLICY                        [NSString stringWithFormat:@"http://%@/html/ipPolicy.html",SERVICE]

#endif /* API_h */

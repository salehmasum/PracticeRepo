//
//  VendorMacro.h
//  ShareCare
//  第三方常量  如KEY
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#ifndef VendorMacro_h
#define VendorMacro_h


// 分享--------------------------------------------------------------------------------------------------

#define SHARE_CONTENT @"Download the app FREE!https://itunes.apple.com/au/app/elecare/id1143531918"



//友盟分享、第三方登录--------------------------------------------------------------------------------------------------
//#define USHARE_APPKEY @"599e67c1aed179488c00162a"//@"599fba96766613548b000ea7"

//GooglePlace
#define GOOGLE_PLACE_KEY @"AIzaSyBpmWCeyov1Yseyd_CqDnWUCdVjN8-yQ_A"
#define GOOGLE_PLACE_COUNTRY @"AU"

#define GOOGLE_WEB_DIRECTIONS_KEY @"AIzaSyB5s9B41ChsqjwyG6gUukRkt23jEhwtyGo"


//Facebook--------------------------------------------------------------------------------------------------
//#ifdef DEBUG 
////本人账号
//#define FACEBOOK_KEY @"2118526531699611"
//#define FACEBOOK_APP_SECRET @"8db6cc13c28a33a6cc42c3d00792cb8d"
//#define USHARE_APPKEY @"5a669b54b27b0a1aa800014d"//@"599fba96766613548b000ea7"
//#else 
////客户提供
#define FACEBOOK_KEY @"481097722250185"
#define FACEBOOK_APP_SECRET @"9c50e2db1131098093ebb435f781d841"
#define USHARE_APPKEY @"599e67c1aed179488c00162a"
//#endif
 

#define FACEBOOK_DEFAULT_LOGIN_PASSWORD @"123456"

//Twitter--------------------------------------------------------------------------------------------------
#define TWITTER_KEY @"fB5tvRpna1CKK97xZUslbxiet"
#define TWITTER_APP_SECRET @"YcbSvseLIwZ4hZg9YmgJPP5uWzd4zr6BpBKGZhf07zzh3oj62K"

 
//Instagram--------------------------------------------------------------------------------------------------
#define INSTAGRAM_KEY @"ffaebc6e158c49e682dc217848478293"
#define INSTAGRAM_APP_SECRET @"e35a33e60da04cf8a8ece74847a5875a"


//Braintree--------------------------------------------------------------------------------------------------
#define BRAINTREE_Sandbox_Tokenization_key    @"sandbox_8wb27tbb_f62fdqhjwk3kys43"
#define BRAINTREE_Production_Tokenization_key @"production_qp5hrhjq_bny3pwbkx95gqj4j"

//[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BraintreeDemoCustomerIdentifier"];

//XMPP--------------------------------------------------------------------------------------------------

#ifdef DEBUG
#define kXMPPHost @"123.56.10.9"
#define kXMPPPort 5222
#define kXMPPDomain @"iz2zec75kyx5uah09u3uopz"
#else
#define kXMPPHost @"ec2-13-54-249-248.ap-southeast-2.compute.amazonaws.com"
#define kXMPPPort 5222
#define kXMPPDomain @"ip-172-31-11-117.ap-southeast-2.compute.internal"
#endif

/*
 openfire_IP: ec2-13-54-249-248.ap-southeast-2.compute.amazonaws.com (13.54.249.248)
 openfire_域名:  ip-172-31-11-117.ap-southeast-2.compute.internal
 端口：5222
 */



#endif /* VendorMacro_h */

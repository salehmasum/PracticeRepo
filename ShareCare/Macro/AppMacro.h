//
//  AppMacro.h
//  ShareCare
//  app相关的宏定义
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


#define ADDRESS_SEPARATED_STRING @"addess*&%"

//颜色
#define MAIN_BACKGROUND_IMAGENAME @"background-image"
#define COLOR_BLUE  TX_RGB(57, 169, 255)
#define COLOR_WHITE TX_RGB(255, 255, 255)
#define COLOR_GRAY  TX_RGB(136, 136, 136)
#define COLOR_PINK  TX_RGB(216, 109, 191)
#define COLOR_INPUT_DARK  TX_RGB(100, 100, 100) 
 
#define COLOR_BACK_BLUE    TX_RGB(65, 171, 252)
#define COLOR_BACK_WHITE   TX_RGB(255, 255, 255)

#define NAVIGATION_SEARCH_MENU_HEIGHT 110*TX_SCREEN_OFFSET+24*iSiPhoneX
#define NAVIGATION_MENU_HEIGHT 96*TX_SCREEN_OFFSET+24*iSiPhoneX
#define MAIN_TABBAR_HEIGHT 49
#define CONDITION_VIEW_HEIGHT 140*TX_SCREEN_OFFSET+24*iSiPhoneX  //首页条件选择view
#define SYSTEM_NAVIGATIONBAR_HEIGHT 64
#define NAVBAR_CHANGE_POINT 50*TX_SCREEN_OFFSET
//首页菜单展开／关闭动画持续时间
#define NAVIGATION_MENU_ANIMATION_DURATION 0.2

//键盘／时间选择器等试图显示动画时间
#define UIKEYBOARD_OPEN_ANIMATION_DURATION 0.15

//拍照／选择图片后图片缩放比例
#define kIMAGEZOOMSCALE 0.5
//创建时最多选择图片张数
#define kMAX_SELECTED_PHOTOS 5

#define StarRatingScale 5.0f//评分换算比例

#define MIN_CHARACTERS 1
//textview
#define TEXTVIEW_LINE_SPACE 7

#define kDEFAULT_IMAGE [UIImage imageNamed:@"default_image"] 
#define kDEFAULT_CREATE_IMAGE [UIImage imageNamed:@"default_image"] 
#define kDEFAULT_HEAD_IMAGE [UIImage imageNamed:@"default_icon_header"]

#define FAVORITE_CELL_PLACEHOLDIMAGE [UIImage imageNamed:@"default_image"]
#define HOME_CELL_PLACEHOLDIMAGE [UIImage imageNamed:@"default_image"]

#define kDEFAULT_HEAD_IMAGETEXT(text) [HeadImage imageWithFrame:CGRectMake(0, 0, 100, 100) BackGroundColor:TX_COLOR_FROM_RGB(0xececec) Text:[text substringToIndex:1] TextColor:[UIColor whiteColor] TextFontOfSize:44]

#define kAPPNAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kAPPVERSION [NSString stringWithFormat:@"%@(%@)",kAPP_SHORT_VERSION,kAPP_BUILD_VERSION]
#define kAPP_SHORT_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAPP_BUILD_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kAPP_BUNDLEID [[NSBundle mainBundle] bundleIdentifier]

#define DocumentsFile(fileName) [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]]

/**
 *  Device info
 */
#define TX_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define TX_IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define TX_IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0 || [UIScreen mainScreen].scale >= 3.0))

#define TX_IS_IPHONE4_OR_LESS (TX_IS_IPHONE && TX_SCREEN_HEIGHT < 568)
#define TX_IS_IPHONE4 (TX_IS_IPHONE && TX_SCREEN_HEIGHT == 480) //320x480
#define TX_IS_IPHONE5 (TX_IS_IPHONE && TX_SCREEN_HEIGHT == 568) //320x568
#define TX_IS_IPHONE5_OR_LESS (TX_IS_IPHONE && TX_SCREEN_HEIGHT <= 568) //320x568
#define TX_IS_IPHONE6 (TX_IS_IPHONE && TX_SCREEN_HEIGHT == 667) //375x667
#define TX_IS_IPHONE6PLUS (TX_IS_IPHONE && TX_SCREEN_HEIGHT == 736) //414x736
#define TX_IS_IPHONE6PLUS_OR_MORE (TX_IS_IPHONE && TX_SCREEN_HEIGHT > 667)

#define IOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iSiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
/**
 *  Get Screen info
 */
#define TX_SCREEN_BOUNDS [[UIScreen mainScreen] bounds]
#define TX_SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define TX_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define TX_SCREEN_OFFSET TX_SCREEN_WIDTH/375.0

#define TX_MATCH_SIZE(size) (size*TX_SCREEN_WIDTH/UI_DESIGN_BASE_RESOLUTION_WIDTH)
#define TX_MATCH_WIDTH(width) (width*TX_SCREEN_WIDTH/UI_DESIGN_BASE_RESOLUTION_WIDTH)
#define TX_MATCH_HEIGHT(height) (height*TX_SCREEN_HEIGHT/UI_DESIGN_BASE_RESOLUTION_HEIGHT)
 

#define kIMAGE_WEEK_MONDAY [UIImage imageNamed:@"monday"]
#define kIMAGE_WEEK_TUESDAY [UIImage imageNamed:@"tuesday"]
#define kIMAGE_WEEK_WEDNESDAY [UIImage imageNamed:@"wednesday"]
#define kIMAGE_WEEK_THURSDAY [UIImage imageNamed:@"thursday"]
#define kIMAGE_WEEK_FRIDAY [UIImage imageNamed:@"friday"]
#define kIMAGE_WEEK_SATURDAY [UIImage imageNamed:@"saturday"]
#define kIMAGE_WEEK_SUNDAY [UIImage imageNamed:@"sunday"]

#define TEXT_LOADING @"loading..." 

#define USERDEFAULT_SET(key,object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];[[NSUserDefaults standardUserDefaults] synchronize];NSLog(@"保存%@=%@",key,object);
#define USERDEFAULT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define USERDEFAULT_SET_LOGIN(value)[[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"login_state"];[[NSUserDefaults standardUserDefaults] synchronize];

#define kUSER_NAME ((NSString *)USERDEFAULT(@"fullName")).length?USERDEFAULT(@"fullName"):USERDEFAULT(@"userName")
#define kUSER_ID  [NSString stringWithFormat:@"%@",USERDEFAULT(@"userId")]
#define kUSER_TOKEN USERDEFAULT(@"token")?USERDEFAULT(@"token"):@""
#define kUSER_USERNAME USERDEFAULT(@"userName")?USERDEFAULT(@"userName"):@""
#define kUSER_FULLNAME USERDEFAULT(@"fullName")?USERDEFAULT(@"fullName"):@""
#define kUSER_USERICON USERDEFAULT(@"userIcon")?USERDEFAULT(@"userIcon"):@""
#define kUSER_PASSWORD USERDEFAULT(@"password")?USERDEFAULT(@"password"):@""
#define kUSER_HASHPASSWORD USERDEFAULT(@"hashPassword")?USERDEFAULT(@"hashPassword"):@""
#define kUSER_EMAIL USERDEFAULT(@"email")?USERDEFAULT(@"email"):@""
#define kUSER_LOGIN_STATE [[NSUserDefaults standardUserDefaults] integerForKey:@"login_state"]

#define kFACEBOOK_USERID USERDEFAULT(@"facebook_uid")?USERDEFAULT(@"facebook_uid"):@""
#define kFACEBOOK_USERNAME USERDEFAULT(@"facebook_name")?USERDEFAULT(@"facebook_name"):@""
#define kFACEBOOK_USERICON USERDEFAULT(@"facebook_usericon")?USERDEFAULT(@"facebook_usericon"):@""

#define kBraintreeCustomerIdentifier USERDEFAULT(@"BraintreeCustomerIdentifier")?USERDEFAULT(@"BraintreeCustomerIdentifier"):@""
#define USERDEFAULT_SET_BraintreeCustimerID(value)[[NSUserDefaults standardUserDefaults] setObject:value forKey:@"BraintreeCustomerIdentifier"];[[NSUserDefaults standardUserDefaults] synchronize];

#define kAPNS_DEVICE_TOKEN USERDEFAULT(@"deviceToken")?USERDEFAULT(@"deviceToken"):@""
#define USERDEFAULT_SET_APNS_DEVICE_TOKEN(value)[[NSUserDefaults standardUserDefaults] setObject:value forKey:@"deviceToken"];[[NSUserDefaults standardUserDefaults] synchronize];


#define USERDEFAULT_COORDINATE_SET(coodinate) [[NSUserDefaults standardUserDefaults] setDouble:coodinate.latitude forKey:@"latitude"];[[NSUserDefaults standardUserDefaults] setDouble:coodinate.longitude forKey:@"longitude"];[[NSUserDefaults standardUserDefaults] synchronize];NSLog(@"%f,%f",coodinate.latitude,coodinate.longitude);
#define kUSER_COORDINATE_LATITUDE  [[NSUserDefaults standardUserDefaults] doubleForKey:@"latitude"]
#define kUSER_COORDINATE_LONGITUDE [[NSUserDefaults standardUserDefaults] doubleForKey:@"longitude"]



//收藏状态改变，用来判断是否需要自动刷新
#define SET_AUTOM_REFRESH_HOME(careType,isRefresh) [[NSUserDefaults standardUserDefaults] setBool:isRefresh forKey:[NSString stringWithFormat:@"home_%d",careType]];[[NSUserDefaults standardUserDefaults] setBool:isRefresh forKey:@"home_popular"];[[NSUserDefaults standardUserDefaults] synchronize];
#define IS_AUTOM_REFRESH_HOME(careType) [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"home_%d",careType]]

#define SET_AUTOM_REFRESH_POPULAR(isRefresh) [[NSUserDefaults standardUserDefaults] setBool:isRefresh forKey:@"home_popular"];[[NSUserDefaults standardUserDefaults] synchronize];
#define IS_AUTOM_REFRESH_POPULAR [[NSUserDefaults standardUserDefaults] boolForKey:@"home_popular"]


#define Faveritor_all 100
#define SET_AUTOM_REFRESH_FAVORITE(careType,isRefresh) [[NSUserDefaults standardUserDefaults] setBool:isRefresh forKey:[NSString stringWithFormat:@"favorite_%d",careType]];[[NSUserDefaults standardUserDefaults] synchronize];
#define IS_AUTOM_REFRESH_FAVORITE(careType) [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"favorite_%d",careType]]

//#define SET_AUTOM_REFRESH_FAVORITE(isRefresh) [[NSUserDefaults standardUserDefaults] setBool:isRefresh forKey:@"FAVORITE"];[[NSUserDefaults standardUserDefaults] synchronize];
//#define IS_AUTOM_REFRESH_FAVORITE [[NSUserDefaults standardUserDefaults] boolForKey:@"FAVORITE"]


#define SET_AUTOM_REFRESH_BOOKINGS(careType,isRefresh) [[NSUserDefaults standardUserDefaults] setBool:isRefresh forKey:[NSString stringWithFormat:@"bookings_%d",careType]];[[NSUserDefaults standardUserDefaults] synchronize];
#define IS_AUTOM_REFRESH_BOOKINGS(careType) [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"bookings_%d",careType]];



#define DEFALUT_ALERT_TEXT @"You must set your address first."

//#ifdef DEBUG  
////#define NSLog(...) NSLog(__VA_ARGS__)  
//#define NSLog(...) printf("》》》》》》》》%s\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
//#else  
//#define NSLog(...){}  
//#endif  


#define CONTENT_TERMS_AND_CONDITINONS    @"Terms and Conditions\
\n——————————\n\
Last Updated: May 15, 2017\
\n\n\n\
ELECARE PRIVACY POLICY\
\n\n\
PLEASE READ THESE TERMS OF SERVICE CAREFULLY AS THEY CONTAIN IMPORTANT INFORMATION REGARDING YOUR LEGAL RIGHTS, REMEDIES AND OBLIGATIONS. THESE INCLUDE VARIOUS LIMITATIONS AND EXCLUSIONS, A CLAUSE THAT GOVERNS THE JURISDICTION AND VENUE OF DISPUTES, AND OBLIGATIONS TO COMPLY WITH APPLICABLE LAWS AND REGULATIONS.\
\n\n\
EleCare is, at its core, an open community dedicated to bringing the world closer together by fostering meaningful, shared experiences among people from all parts of Australia. It is an incredibly diverse community, drawing together individuals of different cultures, values, and norms.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum. "


#define CONTENT_PRIVACY_POLICY           @"Privacy Policy\
\n——————————\n\
Last Updated: May 15, 2017\
\n\n\n\
Our Commitment to Inclusion and Respect\
\n\n\
EleCare is, at its core, an open community dedicated to bringing the world closer together by fostering meaningful, shared experiences among people from all parts of Australia. It is an incredibly diverse community, drawing together individuals of different cultures, values, and norms.\
\n\n\
EleCare is, at its core, an open community dedicated to bringing the world closer together by fostering meaningful, shared experiences among people from all parts of Australia. It is an incredibly diverse community, drawing together individuals of different cultures, values, and norms.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum. "


#define CONTENT_NONDISCRIMINATION_POLICY @"Nondiscrimination Policy\
\n——————————\n\
Last Updated: May 15, 2017\
\n\n\n\
ELECARE PRIVACY POLICY\
\n\n\
1. EleCare (hereinafter referred to as “EleCare”, “we”, “us” or “our”) operates a platform and community marketplace that helps people form offline experiences and relationships directly with one another, where they can create, list, discover and book Babysitting Services, through our mobile application (“Platform”).\
\n\n\
EleCare is, at its core, an open community dedicated to bringing the world closer together by fostering meaningful, shared experiences among people from all parts of Australia. It is an incredibly diverse community, drawing together individuals of different cultures, values, and norms.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum.\
\n\n\
Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed do eiusmod tempor incididunt ut labore et dolore  magna aliqua. Ut enim ad minim veniam, quis nostrud  exercitation ullamco laboris nisi ut aliquip ex ea  commodo consequat. Duis aute irure dolor in  reprehenderit in voluptate velit esse cillum dolore eu  fugiat nulla pariatur. Excepteur sint occaecat cupidatat  non proident, sunt in culpa qui officia deserunt mollit  anim id est laborum. "




#endif /* AppMacro_h */

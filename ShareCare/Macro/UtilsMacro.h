//
//  UtilsMacro.h
//  ShareCare
//  是一些常用的宏定义
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

typedef NS_ENUM(NSInteger, ShareCareType){
    ShareCareTypeAll,
    ShareCareTypeShareCare,
    ShareCareTypebabySittings,
    ShareCareTypeEvents
};


#define CustomLocalizedString(key, comment) NSLocalizedString(key, comment)
/**
 *  Font base define
 */
//#define TX_FONT(size)       [UIFont systemFontOfSize:size*TX_SCREEN_OFFSET]
//#define TX_BOLD_FONT(size)  [UIFont boldSystemFontOfSize:size*TX_SCREEN_OFFSET]
 
//MyriadPro-Semibold   MyriadPro-Regular

#define APP_FONT_NAME @"MyriadPro-Regular"
#define APP_FONT_BOLD_NAME @"MyriadPro-Semibold"


#define TX_FONT(aSize)       [UIFont fontWithName:APP_FONT_NAME size:aSize*TX_SCREEN_OFFSET]
#define TX_BOLD_FONT(aSize)  [UIFont fontWithName:APP_FONT_BOLD_NAME size:aSize*TX_SCREEN_OFFSET]


/**
 *  Color base define
 */
#define TX_RGBA(r,g,b,a)            ([UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a])
#define TX_RGB(r,g,b)               (TX_RGBA(r,g,b,1.0f))

#define TX_CG_RGBA(r,g,b,a)         ([TX_RGBA(r,g,b,a) CGColor])
#define TX_CG_RGB(r,g,b,a)          ([TX_RGBA(r,g,b,1.0f) CGColor])

#define TX_COLOR_FROM_RGBA(rgbValue,alphaValue)    ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue])
#define TX_COLOR_FROM_RGB(rgbValue)    (TX_COLOR_FROM_RGBA(rgbValue,1.0f))

/**
 *  Directory
 */
#define TX_DOCUMENT_PATH(path)    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] \
stringByAppendingPathComponent:path]
#define TX_CACHE_PATH    [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] \
stringByAppendingPathComponent:path]


#define NSStringFromInt(value) [NSString stringWithFormat:@"%ld",value]

#endif /* UtilsMacro_h */

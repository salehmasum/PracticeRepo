//
//  InputInfoVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/16.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputTextBlock)(NSString *text);

typedef enum : NSUInteger {
    AboutContentTypeCreateShareCare,
    AboutContentTypeCreateBabysitting,
    AboutContentTypeCreateEvent,
    AboutContentTypeProfileShareCare,
    AboutContentTypeProfileBabysitting,
    AboutContentTypeProfileEvent
} AboutContentType;

@interface InputInfoVC : UIViewController

@property (assign, nonatomic) AboutContentType careType;//0-sharecare,1-babysitting,2-event
@property (strong, nonatomic) NSString *contentTitle;
@property (strong, nonatomic) NSString *content;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) InputTextBlock inputBlock;

@end

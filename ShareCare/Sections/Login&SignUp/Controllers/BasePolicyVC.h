//
//  BasePolicyVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareVC.h"
@interface BasePolicyVC : UIViewController

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSString   *content;
@property (strong, nonatomic) NSString   *subject;

/*
 0 --> terms and condition
 1  privacy policy
 2  Nodiscrimination policy
 */
@property (assign, nonatomic) NSInteger  policyType;


@end

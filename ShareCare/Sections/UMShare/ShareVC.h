//
//  ShareVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareVC : UIViewController


@property (strong, nonatomic) NSString *imagePath;
@property (strong, nonatomic) NSString *shareTitle;
@property (strong, nonatomic) NSString *shareContent;
- (IBAction)popViewController:(id)sender;

@end

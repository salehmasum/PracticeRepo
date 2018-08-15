//
//  ReportAlertView.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertButtonClickBlock)(void);

@interface ReportAlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UIView *alert;

- (void)showInView:(UIView *)superView 
selectedInappropriate:(AlertButtonClickBlock)inappropriate
         dishonest:(AlertButtonClickBlock)dishonest
              fake:(AlertButtonClickBlock)fake
            cancel:(AlertButtonClickBlock)cancel;


@end

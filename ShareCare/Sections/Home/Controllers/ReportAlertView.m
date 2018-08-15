//
//  ReportAlertView.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ReportAlertView.h"

@interface ReportAlertView (){
    AlertButtonClickBlock inappropriateBlock;
    AlertButtonClickBlock dishonestBlock;
    AlertButtonClickBlock fakeBlock;
    AlertButtonClickBlock cancelBlock;
}

@end

@implementation ReportAlertView
 
- (void)showInView:(UIView *)superView selectedInappropriate:(AlertButtonClickBlock)inappropriate
         dishonest:(AlertButtonClickBlock)dishonest
              fake:(AlertButtonClickBlock)fake
            cancel:(AlertButtonClickBlock)cancel{
      
    [superView addSubview:self];
    
    inappropriateBlock = inappropriate;
    dishonestBlock = dishonest;
    fakeBlock = fake;
    cancelBlock =cancel;
    
    _alert.center = CGPointMake(_alert.center.x, self.frame.size.height+CGRectGetHeight(_alert.frame)/2);
    
    [self show];
}



- (IBAction)cancel:(id)sender {
    cancelBlock(); 
    [self hidden];
}

- (IBAction)didSelectedInappropriate:(id)sender {
    inappropriateBlock(); 
    [self hidden];
}
- (IBAction)didSelectedDishonest:(id)sender {
    dishonestBlock(); 
    [self hidden];
}
- (IBAction)didSelectedFake:(id)sender {
    fakeBlock(); 
    [self hidden];
}


- (void)show{
    
    CGPoint center = _alert.center;
    _backgroundView.alpha = 0.1;
    [UIView animateWithDuration:0.3 animations:^{
        _alert.center = CGPointMake(center.x, center.y-CGRectGetHeight(_alert.frame)); 
        _backgroundView.alpha = 0.3; 
    }completion:^(BOOL finished) {
    }];
}

- (void)hidden{
    CGPoint center = _alert.center;
    
    [UIView animateWithDuration:0.3 animations:^{
        _alert.center = CGPointMake(center.x, center.y+CGRectGetHeight(_alert.frame));
        
        _backgroundView.alpha = 0.1;
        
    }completion:^(BOOL finished) {
        _backgroundView.alpha = 0;
        
        [self removeFromSuperview];
    }];
}


@end

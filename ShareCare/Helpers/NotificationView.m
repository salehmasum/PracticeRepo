//
//  NotificationView.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NotificationView.h"

@implementation NotificationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show{ 
    AudioPlayerHelper *play = [[AudioPlayerHelper alloc] init];
    [play receiveMessage];
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self]; 
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.center = CGPointMake(TX_SCREEN_WIDTH/2.0, 20+CGRectGetHeight(self.frame)/2+iSiPhoneX*24);
    }completion:^(BOOL finished) {
        
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:3];
    }];
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 0;
        self.center = CGPointMake(TX_SCREEN_WIDTH/2.0, -CGRectGetHeight(self.frame)/2-10);
    }];
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.frame =CGRectMake(10, -70, TX_SCREEN_WIDTH-20, 70);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 16;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
    //    
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.icon.layer.masksToBounds = YES;
//        self.icon.layer.cornerRadius = 4;
//        self.icon.contentMode = UIViewContentModeScaleAspectFit;
//        self.icon.clipsToBounds = YES;
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 16;
        bgView.clipsToBounds = YES;
        bgView.image = [UIImage imageNamed:@"background-notification"];
        [self addSubview:bgView];
        
        
        self.layer.shadowOpacity = 0.5;// 阴影透明度
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影的颜色
        
        self.layer.shadowRadius = 3;// 阴影扩散的范围控制
        
        self.layer.shadowOffset = CGSizeMake(3, 3);// 阴影的范围
        
        
        
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 25, 25)];
        self.icon.layer.masksToBounds = YES;
        self.icon.layer.cornerRadius = 4;
        self.icon.contentMode = UIViewContentModeScaleAspectFill;
        self.icon.clipsToBounds = YES;
        [self addSubview:self.icon];
        
        
        
        
        self.lbName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+5, CGRectGetMinY(self.icon.frame), 200, 25)];
        self.lbName.textColor = [UIColor whiteColor];//TX_RGB(90, 90, 90);
        self.lbName.font = TX_BOLD_FONT(18);
        self.lbName.center = CGPointMake(self.lbName.center.x, self.icon.center.y);
        [self addSubview:self.lbName];
        
        self.lbContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.lbName.frame), CGRectGetMaxY(self.icon.frame)+8, CGRectGetWidth(self.frame)-CGRectGetMinX(self.lbName.frame)-10, 25)];
        self.lbContent.textColor = [UIColor whiteColor];//TX_RGB(90, 90, 90);
        self.lbContent.font = TX_FONT(14);
        [self addSubview:self.lbContent];
        
        self.icon.image =kDEFAULT_HEAD_IMAGE;
        self.lbName.text = @"zhumign";
        self.lbContent.text = @"NSURLSession HTTP load failed";
        
        return self;
    }
    return nil;
}

@end

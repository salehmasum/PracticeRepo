//
//  CustomPopupViewController.m
//  ShareCare
//
//  Created by 朱明 on 2018/3/16.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "CustomPopupViewController.h"

@interface CustomPopupViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbtitle;
@property (weak, nonatomic) IBOutlet UILabel *lbContent;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@end

@implementation CustomPopupViewController

- (instancetype)init{
    if (self = [super init]) {
        
        _alertTitle         = @"Want to Create a New Listing?";
        _alertContent       = @"We’re so glad to have you a part of the EleCare Community! Before you begin, please ensure you have completed your profile first.";
        _alertLeftBtnTitle  = @"Not Now";
        _alertRightBtnTitle = @"Yeah, Sure!";
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [self.backgroundImageView addSubview:effectView];
    //设置模糊透明度
    effectView.alpha = .8f;
    
    self.lbContent.text = _alertContent;
    self.lbtitle.text = _alertTitle;
    [self.btnLeft setTitle:_alertLeftBtnTitle forState:UIControlStateNormal];
    [self.btnRight setTitle:_alertRightBtnTitle forState:UIControlStateNormal];
}

//- (void)setAlertContent:(NSString *)alertContent{
//    self.lbContent.text = alertContent;
//}

- (IBAction)cancel:(id)sender {
    [self.view removeFromSuperview];
}
- (IBAction)confirm:(id)sender {
    [self.view removeFromSuperview];
    self.popupBlock();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

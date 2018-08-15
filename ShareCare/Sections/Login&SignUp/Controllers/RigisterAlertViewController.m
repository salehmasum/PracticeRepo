//
//  RigisterAlertViewController.m
//  ShareCare
//
//  Created by 朱明 on 2018/1/10.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "RigisterAlertViewController.h"
#import "BasePolicyVC.h"

@interface RigisterAlertViewController (){
    __weak IBOutlet UIView *_bgView;
    __weak IBOutlet UIImageView *imgAlert;
    __weak IBOutlet UIButton *_btnBack;
    __weak IBOutlet UIButton *_btnContinue;
}
@end

@implementation RigisterAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpTextViewLink];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    effectView.frame = self.view.frame;
//    effectView.contentView.alpha = 0.5;
//    [self.view addSubview:effectView];
//    [self.view sendSubviewToBack:effectView];
    
    

//    _blurView.hidden = YES;
//    _blurView.dynamic = NO;
//    _blurView.tintColor = [UIColor clearColor];
//    _blurView.blurRadius = 30;
}
- (void)setUpTextViewLink{
    
    CGFloat size = 15.0f;
    
    NSString *privacy = CustomLocalizedString(@"Privacy Policy", @"start");
    NSString *terms = CustomLocalizedString(@"Terms and Conditions", @"start");
    NSString *nondiscrimination = CustomLocalizedString(@"Nondiscrimination Policy", @"start");
    NSString *text = CustomLocalizedString(@"By tapping Continue, I agree to\nEleCare’s Terms and Conditions,\nPrivacy Policy and Nondiscrimination Policy.", @"start");
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:TX_FONT(size),NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSRange rangeT = [text rangeOfString:terms];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://terms" 
                    range:rangeT];
    [textStr addAttribute:NSFontAttributeName value:TX_FONT(size) range:rangeT];
    [textStr addAttribute:NSUnderlineStyleAttributeName 
                      value:@1 
                      range:rangeT];
    
    NSRange rangeP = [text rangeOfString:privacy];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://privacy" 
                    range:rangeP];
    [textStr addAttribute:NSFontAttributeName value:TX_FONT(size) range:rangeP];
    [textStr addAttribute:NSUnderlineStyleAttributeName 
                    value:@1 
                    range:rangeP];
    
    
    NSRange rangeN = [text rangeOfString:nondiscrimination];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://nondiscrimination" 
                    range:rangeN];
    [textStr addAttribute:NSFontAttributeName value:TX_FONT(size) range:rangeN];
    [textStr addAttribute:NSUnderlineStyleAttributeName 
                    value:@1 
                    range:rangeN];
    
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: COLOR_INPUT_DARK,
                                     NSUnderlineColorAttributeName: COLOR_INPUT_DARK}; 
    
    
    self.instructTextView.attributedText = textStr;
    self.instructTextView.linkTextAttributes = linkAttributes;
    self.instructTextView.delegate = self;
    self.instructTextView.editable = NO; 
    self.instructTextView.textColor = COLOR_INPUT_DARK; 
    self.instructTextView.textAlignment = NSTextAlignmentCenter; 
    
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange { 
    
    NSLog(@"%@",URL.absoluteString);
    
    BasePolicyVC *viewController = [[BasePolicyVC alloc] init];;
    
    if ([URL.absoluteString isEqualToString:@"onButton://privacy"]) {  
        viewController.content = CONTENT_PRIVACY_POLICY;
        viewController.subject = @"Privacy Policy ";


    } else if ([URL.absoluteString isEqualToString:@"onButton://terms"]){  
        viewController.content = CONTENT_TERMS_AND_CONDITINONS;
        viewController.subject = @"Terms and Conditions";
    }else{ 
        viewController.content = CONTENT_NONDISCRIMINATION_POLICY;
        viewController.subject = @"Nondiscrimination Policy";
    }
    
    //    WebViewVC *webVC = [[WebViewVC alloc] init];
    //    webVC.content = string;
    [self.navigationController pushViewController:viewController animated:YES];
    return NO; // let the system open this URL 
} 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)continueAction:(id)sender {
    _continueBlock();
    [self.view removeFromSuperview];
}

- (IBAction)backAction:(id)sender {
    [self.view removeFromSuperview];
    _goBackBlock();
}

- (void)showAlertInview:(UIView *)target goBack:(AlertViewControllerGoBackBlock)goBackBlock continueClick:(AlertViewControllerContinueBlock)continueBlock{
    _goBackBlock = goBackBlock;
    _continueBlock = continueBlock;
    
    [target addSubview:self.view];
    
    
    _bgView.alpha = 0;
    imgAlert.alpha = 0;
    _btnBack.alpha = 0;
    _btnContinue.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        
        _bgView.alpha = 0.4;
        imgAlert.alpha = 1;
        _btnBack.alpha = 1;
        _btnContinue.alpha = 1;
    }];
    
    
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

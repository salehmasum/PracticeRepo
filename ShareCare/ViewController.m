//
//  ViewController.m
//  ShareCare
//
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialObject.h" 
#import "WebViewVC.h"
#import <CoreLocation/CoreLocation.h> 
#import "BasePolicyVC.h"
#import "MainTabBarController.h"
#import "SignUpVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DKDevice.h"
@interface ViewController (){
    
    RigisterAlertViewController *_alertVC;
}

@property (weak, nonatomic) IBOutlet UILabel *lbTest;
@property (weak, nonatomic) IBOutlet UISwitch *switchService;



@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *createAccountBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) CLLocationManager *locationManager;
- (IBAction)login:(id)sender;
- (IBAction)facebook:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)more:(id)sender;
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)changeService:(UISwitch *)sender {
    
    if (sender.on) {
        USERDEFAULT_SET(@"serviceIP", SERVICE_SANDBOX);
    }else{
        USERDEFAULT_SET(@"serviceIP", SERVICE_PRODUCT);
    }
 //   USERDEFAULT(@"serviceIP");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib. 
    
    
    _switchService.on = [USERDEFAULT(@"serviceIP") isEqualToString:SERVICE_SANDBOX];
    
    NSString *userName =kUSER_EMAIL;
    NSString *facebookId =kFACEBOOK_USERID;
    
    //editing starts
    _lbTest.hidden = YES;
    _switchService.hidden = YES;
    // editing ends
    
//    if ([userName isEqualToString:@"zhuming@126.com"]||
//        [userName isEqualToString:@"zm@126.com"]||
//        [userName isEqualToString:@"koko@gmail.com"]||
//        [userName isEqualToString:@"aa@gmail.com"]||
//        [userName isEqualToString:@"yy@gmail.com"]||
//        [userName isEqualToString:@"lx_java@foxmail.com"]||
//        [facebookId isEqualToString:@"928387593981774"]
//        ) {
//
//        _lbTest.hidden = NO;
//        _switchService.hidden = NO;
//    } else{
//        _lbTest.hidden = YES;
//        _switchService.hidden = YES;
//    }
//
    
    
    
    self.bgImageView.image = [UIImage imageNamed:MAIN_BACKGROUND_IMAGENAME];
    self.instructTextView.backgroundColor = [UIColor clearColor];
    
    self.moreBtn.titleLabel.font = TX_FONT(23);
    [self.moreBtn setTitle:CustomLocalizedString(@"More Options", @"start") forState:UIControlStateNormal];
    
    
    self.loginBtn.titleLabel.font = TX_FONT(18);
    [self.loginBtn setTitle:CustomLocalizedString(@"Log in", @"start") forState:UIControlStateNormal];
    
    
    [self setUpTextViewLink];
//    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
//    
    [self.locationManager requestWhenInUseAuthorization];
    
    [self automLogin];
}


- (void)automLogin{
    switch (kUSER_LOGIN_STATE) {
        case LoginStateFacebook: 
            [self loginForState:LoginStateFacebook];
            break;
        case LoginStateEmail:
            [self loginForState:LoginStateEmail];
            break;
        default: 
            break;
    }
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}
- (void)setUpTextViewLink{
    
    CGFloat size = 15.0f;
    
    NSString *privacy = CustomLocalizedString(@"Privacy Policy", @"start");
    NSString *terms = CustomLocalizedString(@"Terms and Conditions", @"start");
    NSString *nondiscrimination = CustomLocalizedString(@"Nondiscrimination Policy", @"start");
    NSString *text = CustomLocalizedString(@"By tapping Continue or Create Account, I agree to EleCare’s Terms and Conditions, Privacy Policy and Nondiscrimination Policy.", @"start");
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:TX_FONT(size)}];
     
    NSRange rangeT = [text rangeOfString:terms];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://terms" 
                    range:rangeT];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(size) range:rangeT];
    
    NSRange rangeP = [text rangeOfString:privacy];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://privacy" 
                    range:rangeP];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(size) range:rangeP];
    
    
    NSRange rangeN = [text rangeOfString:nondiscrimination];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://nondiscrimination" 
                    range:rangeN];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(size) range:rangeN];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: COLOR_WHITE,
                                     NSUnderlineColorAttributeName: COLOR_WHITE}; 
    
    
    self.instructTextView.attributedText = textStr;
    self.instructTextView.linkTextAttributes = linkAttributes;
    self.instructTextView.delegate = self;
    self.instructTextView.editable = NO; 
    self.instructTextView.textColor = COLOR_WHITE; 
    

}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange { 
    
    NSLog(@"%@",URL.absoluteString);
      
    BasePolicyVC *viewController = [[BasePolicyVC alloc] init];;
    
    if ([URL.absoluteString isEqualToString:@"onButton://privacy"]) {  
        viewController.content = CONTENT_PRIVACY_POLICY;
        viewController.subject = @"Privacy Policy ";
        viewController.policyType = 1;
    } else if ([URL.absoluteString isEqualToString:@"onButton://terms"]){  
        viewController.content = CONTENT_TERMS_AND_CONDITINONS;
        viewController.subject = @"Terms and Conditions";
        viewController.policyType = 0;
    }else{ 
        viewController.content = CONTENT_NONDISCRIMINATION_POLICY;
        viewController.subject = @"Nondiscrimination Policy";
        viewController.policyType = 2;
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


- (IBAction)login:(id)sender {
   
}

- (IBAction)facebook:(id)sender {
    [self showAlertViewControllerToFaceBook:YES];
}

- (IBAction)createAccount:(id)sender {
  //  [self showAlertViewControllerToFaceBook:NO];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    SignUpVC *signVC = (SignUpVC *)[board instantiateViewControllerWithIdentifier: @"SignUpVC"]; 
    [self.navigationController pushViewController:signVC animated:YES];
}

- (IBAction)more:(id)sender {
     
    //share demo 
}
- (void)showAlertViewControllerToFaceBook:(BOOL)facebook{
    if (_alertVC == nil) {
        _alertVC = [[RigisterAlertViewController alloc] init];
        _alertVC.view.backgroundColor = [UIColor clearColor];
        [self addChildViewController:_alertVC];
        _alertVC.view.frame = self.view.bounds;
    }
    
    __weak typeof(self) weakSelf = self;
    [_alertVC showAlertInview:self.view goBack:^{
        NSLog(@"点击取消");
    } continueClick:^{
        
        if (facebook) {
            [weakSelf rigisterForFacebook];
        }else{
            UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
            SignUpVC *signVC = (SignUpVC *)[board instantiateViewControllerWithIdentifier: @"SignUpVC"]; 
            [weakSelf.navigationController pushViewController:signVC animated:YES];
        }
        
        
    }];
}

- (void)rigisterForFacebook{
//#ifdef DEBUG
//
//    NSInteger number = arc4random()%9000+1000;
//    NSString *name = [NSString stringWithFormat:@"fb%ld%ld",number,number];
//    name = iSiPhoneX?@"iphoneX":name;
//    USERDEFAULT_SET(@"facebook_name", name);
//  //  USERDEFAULT_SET(@"facebook_uid", [DKDevice UUIDString]);  //facebook_320561731689112
//
//    //928387593981774  qizhifeng
//    USERDEFAULT_SET(@"facebook_uid", iSiPhoneX?@"facebook_000003":@"928387593981774");  //facebook_320561731689112
//    USERDEFAULT_SET(@"facebook_usericon", @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2343681818,2831876588&fm=27&gp=0.jpg");
//     USERDEFAULT_SET(@"facebook_uid", @"928387593981774");
//    [self loginForState:LoginStateFacebook];
//#else
    __weak typeof(self) weakself = self;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Facebook 
                                        currentViewController:self 
                                                   completion:^(id result, NSError *error) {
                                                       if (error) {
                                                           NSLog(@"facebook login error: %@",error);  
                                                           USERDEFAULT_SET_LOGIN(LoginStateNO);
                                                       } else {
                                                           UMSocialUserInfoResponse *resp = result;
                                                           
                                                           // 授权信息
                                                           NSLog(@"Facebook uid: %@", resp.uid);
                                                           NSLog(@"Facebook openid: %@", resp.openid);
                                                           NSLog(@"Facebook accessToken: %@", resp.accessToken);
                                                           NSLog(@"Facebook expiration: %@", resp.expiration);
                                                           
                                                           // 用户信息
                                                           NSLog(@"Facebook name: %@", resp.name);
                                                            
                                                           // 第三方平台SDK源数据
                                                           NSLog(@"Facebook originalResponse: %@", resp.originalResponse);
                                                           
                                                           if ([resp.originalResponse isKindOfClass:[NSDictionary class]]) {
                                                               NSDictionary *info = resp.originalResponse;
                                                               USERDEFAULT_SET(@"facebook_name", info[@"name"]);
                                                               USERDEFAULT_SET(@"facebook_uid", info[@"id"]); 
                                                               //NSDictionary *picture_data = info[@"picture"][@"data"];
                                                              // USERDEFAULT_SET(@"facebook_usericon", picture_data[@"url"]);
                                                               
                                                               NSString *picPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large&redirect=true&width=400&height=400",info[@"id"]];
                                                               USERDEFAULT_SET(@"facebook_usericon", picPath);
                                                               
                                                               [weakself loginForState:LoginStateFacebook];
                                                           }
                                                       }
                                                   }];
    
//#endif
}


@end

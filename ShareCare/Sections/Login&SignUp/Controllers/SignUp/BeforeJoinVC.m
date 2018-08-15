//
//  BeforeJoinVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BeforeJoinVC.h"
#import "MainTabBarController.h"
#import "XMPPService.h"

@interface BeforeJoinVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (weak, nonatomic) IBOutlet UITextView *textView2;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *declineBtn;

@end

@implementation BeforeJoinVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    
    self.titleLabel.text = CustomLocalizedString(@"Before you join", @"join");
    self.titleLabel.font = TX_BOLD_FONT(35);
    
    //    textview 改变字体的行间距 
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; 
    paragraphStyle.lineSpacing = TEXTVIEW_LINE_SPACE;// 字体的行间距 
    
    NSString *learnMoreStr = CustomLocalizedString(@"Learn More", @"join");
    NSString *text = CustomLocalizedString(@"Whether it’s your first time using EleCare or you’re one of our original carers, please commit to respecting and including everyone in the EleCare community.", @"join");
    NSMutableAttributedString *textStr;
    textStr = [[NSMutableAttributedString alloc]initWithString:text 
                                                    attributes:@{NSFontAttributeName:TX_FONT(15.0f),
                                                                 NSParagraphStyleAttributeName:paragraphStyle}];
    NSRange range = [text rangeOfString:learnMoreStr];
    [textStr addAttribute:NSLinkAttributeName 
                    value:@"onButton://learnmore" 
                    range:range];
    [textStr addAttribute:NSFontAttributeName value:TX_FONT(15.0f) range:range];
    self.textView1.attributedText = textStr;
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: COLOR_BLUE}; 
    self.textView1.linkTextAttributes = linkAttributes;
    self.textView1.delegate = self;
    self.textView1.editable = NO; 
    
    self.textView2.attributedText = [[NSMutableAttributedString alloc]initWithString:CustomLocalizedString(@"I agree to treat everyone in the EleCare community  - regardless of their race, religion, national origin, ethnicity, disability, sex, gender identity, sexual orientation, or age - with respect, and without judgement or bias.", @"join") 
                                                                attributes:@{NSFontAttributeName:TX_FONT(15.0f),
                                                                             NSParagraphStyleAttributeName:paragraphStyle}];
    self.textView2.editable = NO; 
    
    

    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)acceptAction:(id)sender {
    [self loginForState:LoginStateEmail];
}


- (IBAction)declineAction:(id)sender {
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange { 
    
    NSLog(@"%@",URL.absoluteString);
    if ([URL.absoluteString isEqualToString:@"onButton://learnmore"]) {  
        //do something
        NSString *string = WEB_BEFORE_YOU_JOIN_LEARN_MORE;
        WebViewVC *webVC = [[WebViewVC alloc] init];
        webVC.urlString = string;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    return NO; // let the system open this URL 
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

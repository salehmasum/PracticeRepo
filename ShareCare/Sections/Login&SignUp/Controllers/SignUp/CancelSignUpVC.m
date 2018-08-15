//
//  CancelSignUpVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CancelSignUpVC.h"

@interface CancelSignUpVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;
@end

@implementation CancelSignUpVC
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
    /*
    self.cancelBtn.frame = CGRectMake(20, 20, 160*TX_SCREEN_OFFSET, 40*TX_SCREEN_OFFSET);
    self.cancelBtn.backgroundColor = COLOR_BLUE;
    self.cancelBtn.layer.borderColor = COLOR_BLUE.CGColor;
    self.cancelBtn.layer.borderWidth = 1.0;  
    self.cancelBtn.layer.cornerRadius = CGRectGetHeight(self.cancelBtn.frame)/2.0;
    [self.cancelBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = TX_BOLD_FONT(18);
    [self.cancelBtn setTitle:CustomLocalizedString(@"Cancel signup", @"cancel sign up") forState:UIControlStateNormal];
    
    
    self.goBackBtn.frame = CGRectMake(20, 80, 100*TX_SCREEN_OFFSET, 40*TX_SCREEN_OFFSET);
    self.goBackBtn.backgroundColor = COLOR_WHITE;
    self.goBackBtn.layer.borderColor = COLOR_BLUE.CGColor;
    self.goBackBtn.layer.borderWidth = 1.0;  
    self.goBackBtn.layer.cornerRadius = CGRectGetHeight(self.goBackBtn.frame)/2.0;
    [self.goBackBtn setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
    self.goBackBtn.titleLabel.font = TX_BOLD_FONT(18);
    [self.goBackBtn setTitle:CustomLocalizedString(@"Go back", @"cancel sign up") forState:UIControlStateNormal];
    */
    self.textView.attributedText = [self textString];
    self.textView.editable = NO;
    //self.btnView.hidden = YES;
    
    self.btnView.frame = CGRectMake(0, TX_SCREEN_HEIGHT , CGRectGetWidth(self.btnView.frame), CGRectGetHeight(self.btnView.frame));
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelSignUpAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)gobackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableAttributedString *)textString{
    //    textview 改变字体的行间距 
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init]; 
    paragraphStyle.lineSpacing = TEXTVIEW_LINE_SPACE;// 字体的行间距
    NSString *text = CustomLocalizedString(@"Cancel signup?\n \n\nDeclining this commitment means that you won’t have a EleCare account, though you can still browse the site. \n\nWhy did EleCare create the commitment?\nThis commitment is an important step towards creating a community where everyone can truly belong. Discrimination prevents carers, parents and their children from feeling included and welcomed, and we have no tolerance for it. Building a EleCare where everyone can belong hinges on knowing that everyone in our community understands this mission and agrees to help us achieve it.\n\nAs a Carer, what if I have safety concerns about accepting reservations from anyone?\nYou may turn down a parent and/or their child/s for other reasons, not on the basis of race, religion, national origin, ethnicity, sexual orientation, or age. \n\nIn general, when considering a bookin request, reflect on your reasoning to ensure tht bias isn’t a factor. \n\nWhat if I change my mind after declining?\nOnce your account has been cancelled, you can always  sign up again if you change your mind. You’ll still be required to accept the commitment.\n\nHow can I share feedback about the commitment?\nWe welcome your feedback at hello@elecare.net.au. \n\n\n\n\n\n\n\n", @"cancel sign up");
    NSMutableAttributedString *textStr;
    textStr = [[NSMutableAttributedString alloc]initWithString:text 
                                                    attributes:@{NSFontAttributeName:TX_FONT(15.0f),
                                                                 NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSArray *titles = @[CustomLocalizedString(@"Why did EleCare create the commitment?", @"cancel sign up"),
                        CustomLocalizedString(@"As a Carer, what if I have safety concerns about accepting reservations from anyone?", @"cancel sign up"),
                        CustomLocalizedString(@"What if I change my mind after declining?", @"cancel sign up"),
                        CustomLocalizedString(@"How can I share feedback about the commitment?", @"cancel sign up"),
                        ];
    for (NSString *str in titles) {
        NSRange range = [text rangeOfString:str];
        [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(15) range:range];
    }
    NSString *titleString = CustomLocalizedString(@"Cancel signup?", @"cancel sign up");
    NSRange range1 = [text rangeOfString:titleString];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(35) range:range1];
     
    
    // 插入图片
    NSTextAttachment * att = [[NSTextAttachment alloc]init];
    att.image = [UIImage imageNamed:@"icon_text_line"];
    NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:att];
    [textStr insertAttributedString:attStr atIndex:15];
     
    
    return textStr;
}

#pragma mark - 代理方法，当scrollview处于滚动状态时执行  在此判断是否滚动到底部
- (void)scrollViewDidScroll:(UIScrollView *)sv
{
    CGPoint offset = sv.contentOffset;
    CGRect bounds = sv.bounds;
    CGSize size = sv.contentSize;
    UIEdgeInsets inset = sv.contentInset;
    
    CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    
    self.btnView.frame = CGRectMake(0, TX_SCREEN_HEIGHT - (CGRectGetHeight(self.btnView.frame)-(maximumOffset - currentOffset)), CGRectGetWidth(self.btnView.frame), CGRectGetHeight(self.btnView.frame));
    
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

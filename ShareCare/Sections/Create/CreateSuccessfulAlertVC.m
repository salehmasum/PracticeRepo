//
//  CreateSuccessfulAlertVC.m
//  ShareCare
//
//  Created by 朱明 on 2018/3/20.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "CreateSuccessfulAlertVC.h"
#import "BasePolicyVC.h"

@interface CreateSuccessfulAlertVC ()<UITextViewDelegate>

@property (strong, nonatomic) CreateSuccessfulAlertBlock confirmBlock;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation CreateSuccessfulAlertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *message = @"As per Terms and Conditions, we will be reviewing your identification. If you are then verified you will be registered as an official EleCare Babysitter and make your profile available to Parents.";
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:TX_FONT(14),
                                 NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message 
                                                                                    attributes:attributes];
    
    NSString *conditionsStr = @"Terms and Conditions";
    NSRange range = [message rangeOfString:conditionsStr];
    [messageText addAttribute:NSUnderlineStyleAttributeName 
                        value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] 
                        range:range]; // 下划线类型  
    //    [messageText addAttribute:NSUnderlineColorAttributeName 
    //                        value:[UIColor blueColor] 
    //                        range:range]; // 下划线颜色  
    
    [messageText addAttribute:NSLinkAttributeName 
                        value:@"onButton://terms" 
                        range:range];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSUnderlineColorAttributeName:  [UIColor blackColor]}; 
    
     
    _textView.attributedText = messageText;
    _textView.linkTextAttributes = linkAttributes;
    _textView.textAlignment = NSTextAlignmentCenter; 
    
    
}
- (IBAction)confirm:(id)sender {
    _confirmBlock();
    [self.view removeFromSuperview];
}

- (void)showAlertInview:(UIView *)target confirm:(CreateSuccessfulAlertBlock)confirmBlock{
    _confirmBlock = confirmBlock;
    [target addSubview:self.view];
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange { 
    
    NSLog(@"%@",URL.absoluteString);
    
    BasePolicyVC *viewController = [[BasePolicyVC alloc] init];;
    
    
    viewController.content = CONTENT_TERMS_AND_CONDITINONS;
    viewController.subject = @"Terms and Conditions";
 
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController pushViewController:viewController animated:YES];
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

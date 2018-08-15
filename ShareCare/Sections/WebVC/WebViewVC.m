//
//  WebViewVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "WebViewVC.h"

@interface WebViewVC ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.webView.scrollView.delegate = self;
    if (_urlString) {
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
    }
    
    if (_content) {
        
        
        _content = [NSString stringWithFormat:@"<html> \n" 
                    "<head> \n" 
                    "<style type=\"text/css\"> \n" 
                    "body {font-family: \"%@\"; font-size:30pxf;}\n" 
                    "</style> \n" 
                    "</head> \n"
                    "<body>%@</body> \n"
                    "</html>", @"宋体",_content];
        
        
        [self.webView loadHTMLString:_content baseURL:nil];
    }
}
 

- (void)webViewDidStartLoad:(UIWebView *)webView{
   // [DKProgress showLoadingInView:self.view withStatus:CustomLocalizedString(@"loading...", @"web")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
   // [DKProgress dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   // [DKProgress showErrorWithStatus:CustomLocalizedString(@"Request faild", @"web")];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_CHANGE_POINT) {
        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
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

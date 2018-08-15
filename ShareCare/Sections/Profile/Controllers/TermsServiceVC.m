//
//  TermsServiceVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/3.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "TermsServiceVC.h"

@interface TermsServiceVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *openButn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TermsServiceVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"terms"];
//    _dataSource = @[@{@"title":@"Terms of Service",           @"url":WEB_PROFILE_TERMS_OF_SERVICE},
//                    @{@"title":@"Nondiscrimination Policy",   @"url":WEB_PROFILE_NONDISCRIMINATION_POLICY},
//                    @{@"title":@"Payments Terms of Service " ,@"url":WEB_PROFILE_PAYMENTS_TERMS_OF_SERVICE},
//                    @{@"title":@"Privacy Policy ",            @"url":WEB_PROFILE_PRIVACY_POLICY},
//                    @{@"title":@"EleCare/Babysitter Policy",@"url":WEB_PROFILE_SHARECARE_OR_BABYSITTINER_POLICY},
//                    @{@"title":@"Refunds",                    @"url":WEB_PROFILE_REFUNDS},
//                    @{@"title":@"IP Policy",                  @"url":WEB_PROFILE_IP_POLICY},
//                    ];
    
    _dataSource = @[@{@"title":@"Terms of Service",           @"url":WEB_PROFILE_TERMS_OF_SERVICE},
                    @{@"title":@"Nondiscrimination Policy",   @"url":WEB_PROFILE_NONDISCRIMINATION_POLICY},
                    @{@"title":@"Privacy Policy ",            @"url":WEB_PROFILE_PRIVACY_POLICY}
                    ];
    
    CGRect rect =self.tableView.frame;
    rect.size.height = 40;
    self.tableView.frame = rect;
    self.tableView.userInteractionEnabled= NO;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.font = TX_BOLD_FONT(17);
    
    _lbTitle.text = _dataSource[0][@"title"];
    NSLog(@"%@",_dataSource[0][@"url"]);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_dataSource[0][@"url"]]]];
}
- (IBAction)open:(UIButton *)sender {
    sender.enabled= NO;
    __weak typeof(self) weakSelf = self;
    CGFloat height = (sender.selected?1:3)*40;
    CGRect rect =self.tableView.frame;
    rect.size.height = height;
    [UIView animateWithDuration:0.2 animations:^{ 
        
        self.tableView.frame = rect;
        
    }completion:^(BOOL finished) {
        weakSelf.imageView.image = [UIImage imageNamed:sender.selected?@"V-button-white":@"x-button-white"];
        weakSelf.tableView.userInteractionEnabled = !sender.selected;
        sender.selected = !sender.selected; 
        sender.enabled= YES;
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"terms" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = TX_FONT(16);
    cell.textLabel.textColor = COLOR_WHITE;
    cell.textLabel.text = _dataSource[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = TX_BOLD_FONT(17);
    
    _lbTitle.text = _dataSource[indexPath.row][@"title"]; 
    [self open:_openButn];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_dataSource[indexPath.row][@"url"]]]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.font = TX_FONT(16);
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithStatus:TEXT_LOADING];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}



@end

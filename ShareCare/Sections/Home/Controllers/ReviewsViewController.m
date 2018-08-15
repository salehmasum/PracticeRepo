//
//  ReviewsViewController.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ReviewsViewController.h"

@interface ReviewsViewController ()

@end

@implementation ReviewsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor clearColor] colorWithAlphaComponent:0]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;  
    UINib *reviewsCellNib = [UINib nibWithNibName:NSStringFromClass([ReviewsCell class]) bundle:nil]; 
    [self.tableView registerNib:reviewsCellNib forCellReuseIdentifier:@"ReviewsCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   // [self requestDetails];
}
- (NSString *)api{
    return [NSString stringWithFormat:@"%@%@/%@",API_REVIEW_LIST,self.reviewType,self.reviewTypeId];
}



- (ReportAlertView *)reportAlert{
    if (!_reportAlert) {
        _reportAlert = [[[NSBundle mainBundle]loadNibNamed:@"ReportAlertView" owner:self options:nil]objectAtIndex:0]; 
        _reportAlert.frame = self.view.frame;
    }
    return _reportAlert;
}
#pragma mark -tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
//    return _reviewDtoList.count;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell configIcon:dic[@"userIcon"] 
            userName:dic[@"userName"] 
                time:dic[@"createTime"] 
             content:dic[@"experience"]];
    cell.reviewId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    
    return cell;
}



#pragma mark -ReviewsCellDelagete

- (void)reviewCellDidReport:(id)sender{
    
    //   __weak HBaseDetailVC *weakSelf = self; 
    [self.reportAlert showInView:[UIApplication sharedApplication].keyWindow selectedInappropriate:^{
        [self reportIndex:0 reviewId:sender];
    } dishonest:^{
        [self reportIndex:1 reviewId:sender];
    } fake:^{
        [self reportIndex:2 reviewId:sender];
    } cancel:^{
        
    }];
    
} 
- (void)reportIndex:(NSInteger)index reviewId:sender{
    [ShareCareHttp GET:@"/v1/review/report/" withParaments:@[[NSString stringWithFormat:@"%ld",index],sender] withSuccessBlock:^(id response) {
        [self showAlert];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)showAlert{
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"Your Report has been sent to our service department."
                                          message:@"Thank you, we will get back to shortly." 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"OK", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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

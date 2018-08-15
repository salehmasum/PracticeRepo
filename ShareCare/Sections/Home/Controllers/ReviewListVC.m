//
//  ReviewListVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ReviewListVC.h"

@interface ReviewListVC ()

@end

@implementation ReviewListVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // self.automaticallyAdjustsScrollViewInsets = NO;  
    UINib *reviewsCellNib = [UINib nibWithNibName:NSStringFromClass([ReviewsCell class]) bundle:nil]; 
    [self.tableView registerNib:reviewsCellNib forCellReuseIdentifier:@"ReviewsCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (NSString *)api{
    return [NSString stringWithFormat:@"%@%@/%@?",API_REVIEW_LIST,self.reviewType,self.reviewTypeId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 50)];
    headerView.backgroundColor=COLOR_WHITE;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, TX_SCREEN_WIDTH, 50)];
    label.textColor = COLOR_BLUE;
    label.font = TX_BOLD_FONT(22);
    label.text = @"Reviews";
    [headerView addSubview:label];
    return headerView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
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



@end

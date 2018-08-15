//
//  SReviewsAboutYouVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SReviewsAboutYouVC.h"
#import "ReviewsCell.h"

@interface SReviewsAboutYouVC ()<ReviewsCellDelagete>

@end

@implementation SReviewsAboutYouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    UINib *reviewsCellNib = [UINib nibWithNibName:NSStringFromClass([ReviewsCell class]) bundle:nil]; 
    [self.tableView registerNib:reviewsCellNib forCellReuseIdentifier:@"ReviewsCell"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 280)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 12, TX_SCREEN_WIDTH-56, 189)];
        label.numberOfLines = 0;
        label.textColor = COLOR_GRAY;
        label.font = TX_FONT(15);
        label.text = @"Reviews are written at the end of a booking through EleCare. Reviews you’ve received will be visible both here and on your public listings.\n\n\n\nNo one has reviewed you yet.";
        [_headerView addSubview:label];
    }
    return _headerView;
}

- (NSString *)api{
    return [NSString stringWithFormat:@"%@%ld?",API_REVIEW_ME,self.reviewType];
}

- (NSInteger)reviewType{
    return 0;
}
- (void)resetUI{
    if (self.dataSource.count) {
        self.tableView.tableHeaderView = [UIView new];
    }else{
        self.tableView.tableHeaderView = self.headerView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


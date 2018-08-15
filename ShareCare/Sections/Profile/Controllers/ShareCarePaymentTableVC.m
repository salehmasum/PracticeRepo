//
//  ShareCarePaymentTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareCarePaymentTableVC.h"
#import "ShareCarePaymentCell.h"
#import "ShareCareAddpaymentInfoVC.h"
#import "CreditCardModel.h"
@interface ShareCarePaymentTableVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UIButton *btAddPayment;
@property (weak, nonatomic) IBOutlet UILabel *lbWarning;

@property (weak, nonatomic) IBOutlet UILabel *lbContent1;
@property (weak, nonatomic) IBOutlet UILabel *lbContent2;


@end

@implementation ShareCarePaymentTableVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [NSMutableArray array];
    
    self.lbWarning.hidden = YES;
    self.tableView.hidden = YES;
    [self.btAddPayment setImage:[UIImage imageNamed:@"add-payment-method"] 
                       forState:UIControlStateNormal];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ShareCarePaymentCell class]) bundle:nil] forCellReuseIdentifier:@"payment"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self queryPaymentMethods];
}

-(void)queryPaymentMethods
{
   // [SVProgressHUD showWithStatus:TEXT_LOADING];
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_PAYMENT_CREDITCARD_LIST withParaments:@[] withSuccessBlock:^(id response) {
        
       
        [weakSelf handleResponse:response];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) { 
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)handleResponse:(id)response{
    self.dataSource = [NSMutableArray array];
    if ([response isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary *dic in response) {
            
            CreditCardModel *card = [CreditCardModel modelWithDictionary:dic];
            if (card.cardType.integerValue == 1 ||card.cardType.integerValue == 2) {
                [self.dataSource addObject:card];
            }
            
        } 
    }
    [self.tableView reloadData];
    [self updateUI];
}
- (void)updateUI{
    if (_dataSource.count) {
        self.lbWarning.hidden = NO;
        self.lbContent1.hidden = YES;
        self.lbContent2.hidden = YES;
        self.tableView.hidden = NO;
        [self.btAddPayment setImage:[UIImage imageNamed:@"add-another-payment-method"] 
                           forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }
    
}

- (IBAction)addPayment:(id)sender {
  //  _dataSource = @[@"",@"",@""];
     
    ShareCareAddpaymentInfoVC *paymentVC  = [[ShareCareAddpaymentInfoVC alloc] init]; 
    paymentVC.card = [[CreditCardModel alloc] init];
    [self.navigationController pushViewController:paymentVC animated:YES];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareCarePaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payment" forIndexPath:indexPath];
    
    // Configure the cell...
    CreditCardModel *card = _dataSource[indexPath.row];
    NSInteger cardType = [card.cardType integerValue];
     
    if (cardType == 2) {  
        cell.lbPayName.text = card.email;
        cell.logo.image = [UIImage imageNamed:@"paypal-logo"];
        cell.lbBankName.text = @"";
    }else{  
        cell.lbPayName.text = card.payee;
        cell.logo.image = [UIImage imageNamed:@"bank-transfer"];
        cell.lbBankName.text = card.bankName; 
    } 
     
    cell.row = indexPath.row;
    cell.editBlock = ^(NSInteger index) {
        [self editPaymentAtIndex:index];  
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)editPaymentAtIndex:(NSInteger)index{
    ShareCareAddpaymentInfoVC *paymentVC  = [[ShareCareAddpaymentInfoVC alloc] init]; 
    paymentVC.card = _dataSource[index];
    paymentVC.isEdit = YES;
    [self.navigationController pushViewController:paymentVC animated:YES];
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";//默认文字为 Delete
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self removePayMethodAtIndex:indexPath.row];
    }
    
}
- (void)removePayMethodAtIndex:(NSInteger)index{
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    CreditCardModel *card = _dataSource[index];
    [ShareCareHttp GET:API_PAYMENT_CREDITCARD_DELETE 
         withParaments:@[card.idValue]
      withSuccessBlock:^(id response) {
          [SVProgressHUD showSuccessWithStatus:@"Deleted Successed!"];
          
          [self.dataSource removeObject:card];
          [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
          [weakSelf updateUI];
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
      }];
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

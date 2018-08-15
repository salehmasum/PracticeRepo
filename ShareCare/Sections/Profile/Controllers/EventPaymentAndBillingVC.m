//
//  EventPaymentAndBillingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventPaymentAndBillingVC.h"
#import "EventPaymentGuidVC.h"
@interface EventPaymentAndBillingVC ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

@end

@implementation EventPaymentAndBillingVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestCards];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"payment"];
    
    _plusBtn.hidden = YES;
 //   [self setupRefresh];
    
    self.tableView.tableFooterView = [UIView new];
}


/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [refreshControl beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:refreshControl];
}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_PAYMENT_CREDITCARD_LIST withParaments:@[] withSuccessBlock:^(id response) {
        
        weakSelf.dataSource = [NSMutableArray array];
        if ([response isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in response) {
                [weakSelf.dataSource addObject:[CreditCardModel modelWithDictionary:dic]];
            } 
        }
        [weakSelf.tableView reloadData];
        [weakSelf updateUI];
        // 3. 结束刷新
        [control endRefreshing];
    } withFailureBlock:^(NSString *error) {
        // 3. 结束刷新
        [control endRefreshing];
    }];
}

- (void)requestCards{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_PAYMENT_CREDITCARD_LIST withParaments:@[] withSuccessBlock:^(id response) {
        
        [weakSelf handleResponse:response];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)handleResponse:(id)response{
    self.dataSource = [NSMutableArray array];
    if ([response isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary *dic in response) {
            
            CreditCardModel *card = [CreditCardModel modelWithDictionary:dic];
            if (card.cardType.integerValue == 0 ||card.cardType.integerValue == 2) {
                 [self.dataSource addObject:card];
            }
           
        } 
    }
//    {
//        
//        CreditCardModel *card = [[CreditCardModel alloc] init];
//        card.cardType = @"2";
//        card.email = @"Vector@gmai.com";
//        [self.dataSource addObject:card];
//    }
//    
//    {
//        
//        CreditCardModel *card = [[CreditCardModel alloc] init];
//        card.cardType = @"0";
//        card.cardNumber = @"1122334455667788";
//        [self.dataSource addObject:card];
//    }
    [self.tableView reloadData];
    [self updateUI];
}

- (void)updateUI{
    CGRect rect = _titleView.frame;
    if (self.dataSource.count == 0) {
        rect.size.width = TX_SCREEN_WIDTH;
        self.tableView.tableHeaderView = _headerView;
        _plusBtn.hidden = YES;
    }else{
        rect.size.width = 200;
        self.tableView.tableHeaderView = [UIView new];
        _plusBtn.hidden = NO;
    }
   // _titleView.frame = rect;
    [self.tableView reloadData];
}
- (NSString *)dealWithString:(NSString *)string
{
    if (string.length<=10) {
        return string;
    }
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < string.length; i++) { 
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4 && i<9) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }else{
            doneTitle = [NSString stringWithFormat:@"%@", doneTitle];
        }
        
    }
    NSLog(@"%@", doneTitle);
    return doneTitle;
}

- (IBAction)addPaymentMethod:(id)sender {
    
    EventPaymentGuidVC *guidVc = [[EventPaymentGuidVC alloc] init];
    [self.navigationController pushViewController:guidVc animated:YES];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"payment" forIndexPath:indexPath];
  //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font =TX_FONT(20);
    cell.textLabel.textColor = TX_RGB(136, 136, 136);
  //  cell.textLabel.text = @"John Doe MasterCard";
    
    CreditCardModel *card = self.dataSource[indexPath.row];
    NSInteger cardType = [card.cardType integerValue];
    
     
    if (cardType == 2) {  
        cell.textLabel.text = card.email;
    }else{  
        cell.textLabel.text = [Util dealWithString:card.cardNumber];
    } 
    
   
    
    
    
    
    
//    if (card.cardType.integerValue == 2) {
//        cell.textLabel.text = [NSString stringWithFormat:@"%@",card.email];
//    }else if (card.cardType.integerValue == 0) { 
//        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",card.firstName,card.lastName];
//    }
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minus"]];
    cell.indentationLevel =2;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexPath.row;
    [button addTarget:self action:@selector(removePayMethodAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(TX_SCREEN_WIDTH-150, 0, 70, 50);
    [button setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    cell.accessoryView = button;
    
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_payBlock) {
        CreditCardModel *card = self.dataSource[indexPath.row];
        _payBlock(card);
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)removePayMethodAtIndex:(UIButton *)sender{
    
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    CreditCardModel *card = self.dataSource[sender.tag];
    [ShareCareHttp GET:API_PAYMENT_CREDITCARD_DELETE 
         withParaments:@[card.idValue]
       withSuccessBlock:^(id response) {
           [SVProgressHUD showSuccessWithStatus:@"Deleted Successed!"];
           
           [self.dataSource removeObject:card];
           [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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

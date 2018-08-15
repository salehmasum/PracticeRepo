//
//  SelectProfileVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SelectProfileVC.h"
#import "WhosComingCell.h"
#import "ProfileModel.h"
#import "NewChildrenTableVC.h"
@interface SelectProfileVC ()

@end

@implementation SelectProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *checkNib = [UINib nibWithNibName:NSStringFromClass([WhosComingCell class]) bundle:nil];
    [self.tableView registerNib:checkNib forCellReuseIdentifier:@"WhosComingCell"];
    
    [self setupRefresh];
}


/**
 *  集成下拉刷新
 */
-(void)setupRefresh
{
    //1.添加刷新控件
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [control beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:control];
}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    __weak typeof(self) weakself = self;
    __weak typeof(UIRefreshControl *) weakControl = control;
    ShareCareModel *shareCare = (ShareCareModel *)self.item;
    NSArray *array = @[self.booking.startDate,
                       self.booking.endDate]; 
    
    NSDictionary *dic = @{@"listingId":shareCare.idValue,
                          @"listingType":@"0",
                          @"startDate":self.booking.startDate,
                          @"endDate":self.booking.endDate
                          };
    [ShareCareHttp POST:@"/v1/booking/me/children/list" withParaments:dic withSuccessBlock:^(id response) {
          
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dic in response) { 
            ChildrenModel *child = [ChildrenModel modelWithDictionary:dic];
            if([self.joinChildrens containsObject:child]){
                NSLog(@"自己的孩子");
            } 
            
            
            if (child.childStatus.integerValue == ChildStateConfirmed || child.childStatus.integerValue == ChildStateBusy) {
                child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateBusy];
            }else{
                NSInteger ageValue = [[child.age componentsSeparatedByString:@"yrs"].firstObject integerValue];
                if (![self vailableAge:ageValue withRange:shareCare.babyAgeRangeModel]) {
                    
                    child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateCheckAgeRange];
                }else{
                    
                    child.childStatus = [NSString stringWithFormat:@"%ld",(unsigned long)ChildStateAvailable];
                }
            }
            
            
            [temp addObject:child];
        }
        weakself.childrens = temp;
        if (temp.count==0) {
           // [weakself addChildren];
        }
        [weakself.tableView reloadData];
        [weakControl endRefreshing];
    } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error]; 
        [weakControl endRefreshing];
    }];
}
- (BOOL)vailableAge:(NSInteger)age withRange:(AgeRangeModel *)ageRange{
    if (ageRange.age0_1 && age<=1) {
        return YES;
    }
    if (ageRange.age1_2 && age>=1 && age<=2) {
        return YES;
    } 
    if (ageRange.age2_3 && age>=2 && age<=3) {
        return YES;
    } 
    if (ageRange.age3_5 && age>=3 && age<=5) {
        return YES;
    } 
    if (ageRange.age5 && age>=5) {
        return YES;
    }  
    return NO;
}
- (void)addChildren{
    NewChildrenTableVC *childrenVC = [[NewChildrenTableVC alloc] initWithStyle:UITableViewStyleGrouped];
    childrenVC.childrens = [NSMutableArray array];
    [self.navigationController pushViewController:childrenVC animated:YES];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _childrens.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84*TX_SCREEN_OFFSET;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                           forIndexPath:indexPath];
    ChildrenModel *children = _childrens[indexPath.row];
    cell.lbAge.text = children.fullName;
    cell.child = children;
    cell.minBtn.hidden = YES;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChildrenModel *children = _childrens[indexPath.row];
    if (children.state == ChildStateAvailable) {
        [self.navigationController popViewControllerAnimated:NO];
        _selectProfile(children);
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

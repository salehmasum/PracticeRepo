//
//  HConditionTypeVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/10.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HConditionTypeVC.h"

@interface HConditionTypeVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HConditionTypeVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = @[@{@"title":CustomLocalizedString(@"EleCare", @"search"),
                      @"desc":CustomLocalizedString(@"EleCare, similar to a nanny, is where a carer provides care for three or less children -facilitating cost-effective care, and allowing the parent to decide who their child is spending time with.", @"search")},
                    
                    @{@"title":CustomLocalizedString(@"BabySitting", @"search"),
                      @"desc":CustomLocalizedString(@"Where a trusted carer comes to your home to provide care for your children.", @"search")},
                    
                    @{@"title":CustomLocalizedString(@"Events", @"search"),
                      @"desc":CustomLocalizedString(@"Post your events or join somebody else’s - Zoo, Aquarium, Sunday Walk? You Decide. ", @"search")}];
     
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    //cell自适应高度
//    self.tableView.estimatedRowHeight = 60; 
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140*TX_SCREEN_OFFSET;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"search"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"search"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.textLabel.font = TX_FONT(30);
        cell.detailTextLabel.font = TX_FONT(18);
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row][@"title"];
    cell.detailTextLabel.text = _dataSource[indexPath.row][@"desc"];//[NSString stringWithFormat:@"%@\n%@",_dataSource[indexPath.row][@"title"],_dataSource[indexPath.row][@"desc"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            
            [self.delegate conditionType:ShareCareTypeShareCare];
            break;
        case 1:
            
            [self.delegate conditionType:ShareCareTypebabySittings];
            break;
        case 2:
            
            [self.delegate conditionType:ShareCareTypeEvents];
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
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

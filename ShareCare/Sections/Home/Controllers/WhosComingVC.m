//
//  WhosComingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "WhosComingVC.h"
#import "SelectProfileVC.h"
#import "ProfileModel.h"
#import "ReviewBookingVC.h"
@interface WhosComingVC ()
 
@end

@implementation WhosComingVC

@synthesize dataSource = _dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  _dataSource = [NSMutableArray array];
    [self requestBookingChild];
    
    _myChildrens = [NSMutableArray array]; 
    UINib *checkNib = [UINib nibWithNibName:NSStringFromClass([WhosComingCell class]) bundle:nil];
    [self.tableView registerNib:checkNib forCellReuseIdentifier:@"WhosComingCell"];
    if ([((ShareCareModel *)_item) respondsToSelector:@selector(moneyPerDay)]) { 
        _lbPrice.text = [NSString stringWithFormat:@"$%@/day",((ShareCareModel *)_item).moneyPerDay];
    }
    
    
}
- (void)requestBookingChild{
    self.lbLocation.text = [NSString stringWithFormat:@"%ld of %@ places currently occupied",self.dataSource.count,((ShareCareModel *)self.item).childrenNums];
}

- (IBAction)add:(id)sender { 
    __weak typeof(self) weakSelf = self;
    SelectProfileVC *selectProfileVC = [[SelectProfileVC alloc] init];
    selectProfileVC.booking = _booking;
    selectProfileVC.item = self.item;
    selectProfileVC.joinChildrens = self.dataSource;
    selectProfileVC.selectProfile = ^(ChildrenModel *child) {
        if (![weakSelf checkIsSelectedChild:child]) {
            
            child.timePeriod = weakSelf.booking.timePeriod;
            
            [weakSelf.myChildrens addObject:child];
            [weakSelf.dataSource insertObject:child atIndex:0];
            
            [weakSelf.tableView reloadData];
            [weakSelf resetQuestBtnStatus]; 
            
            weakSelf.booking.remainingPlace = ((ShareCareModel *)weakSelf.item).childrenNums.integerValue-weakSelf.dataSource.count;
            weakSelf.plusBtn.hidden = !(weakSelf.booking.remainingPlace);
        }
    };
    [self.navigationController pushViewController:selectProfileVC animated:YES];
    
}

- (BOOL)checkIsSelectedChild:(ChildrenModel *)child{
    for (ChildrenModel *objec in _myChildrens) {
        if ([child.fullName isEqualToString:objec.fullName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84*TX_SCREEN_OFFSET;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                                  forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ChildrenModel *children = _dataSource[indexPath.row];
    cell.lbAge.text = children.age;
    cell.child = children;
    cell.minBtn.hidden = ![self.myChildrens containsObject:children];
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^{
        [weakSelf removeItemAtIndex:indexPath.row];
        weakSelf.plusBtn.hidden = NO;
    };
    return cell;
    
} 
- (void)removeItemAtIndex:(NSInteger)index{
    [_myChildrens removeObject:_dataSource[index]];
    [_dataSource removeObjectAtIndex:index]; 
    [self.tableView reloadData];
    [self resetQuestBtnStatus];
}

- (void)resetQuestBtnStatus{
    self.requestBtn.enabled = _myChildrens.count;
}

- (IBAction)requestToBook:(id)sender {
    
    _booking.whoIsComings = _myChildrens;
    
    ReviewBookingVC *bookingDetail=[[ReviewBookingVC alloc] init];
    bookingDetail.item = self.item;
    bookingDetail.booking = _booking;
    [self.navigationController pushViewController:bookingDetail animated:YES];
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

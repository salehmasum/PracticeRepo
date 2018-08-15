//
//  SReviewByYouVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SReviewByYouVC.h"
#import "ReviewsCell.h"
#import "PastCell.h"
#import "BookingModel.h"
#import "BookingReviewVC.h"

@interface SReviewByYouVC ()<BookingAddReviewDelegate>{
    NSInteger _requestCount;
    NSInteger _selectRow;
}
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSMutableArray *bookings;

@end

@implementation SReviewByYouVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = COLOR_WHITE;
    UINib *reviewsCellNib = [UINib nibWithNibName:NSStringFromClass([ReviewsCell class]) bundle:nil]; 
    [self.tableView registerNib:reviewsCellNib forCellReuseIdentifier:@"ReviewsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PastCell  class]) bundle:nil] forCellReuseIdentifier:@"past"];
    
    _selectRow = -1;
    _bookings = [NSMutableArray array];
    self.tableView.tableHeaderView = self.headerView;
    
}
- (void)resetUI{
    if (self.dataSource.count) {
        self.tableView.tableHeaderView = [UIView new];
    }else{
        self.tableView.tableHeaderView = self.headerView;
    }
}
- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 280)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 34, TX_SCREEN_WIDTH-56, 62)];
        label.numberOfLines = 0;
        label.textColor = COLOR_INPUT_DARK;
        label.font = TX_FONT(25);
        label.text = @"Reviews to Write";
        [_headerView addSubview:label];
        
        UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(28, 113, TX_SCREEN_WIDTH-56, 62)];
        lbDesc.numberOfLines = 0;
        lbDesc.textColor = COLOR_GRAY;
        lbDesc.font = TX_FONT(15);
        lbDesc.text = @"Nobody to review right now.\nLooks like it’s time to make a booking! ";
        [_headerView addSubview:lbDesc];
    }
    return _headerView;
}

- (NSString *)api{
    return [NSString stringWithFormat:@"%@%ld?",API_REVIEW_OTHER,self.reviewType];
}

- (NSInteger)reviewType{
    return 0;
}


- (void)refreshStateChange:(UIRefreshControl *)control{
     
    
   // [SVProgressHUD showWithStatus:TEXT_LOADING];
    _requestCount = 0;
    [self requestBookins];
    [self requestReviewList];
}

- (void)requestBookins{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:[NSString stringWithFormat:@"%@%ld",API_BOOKING_PENDING_REVIEW_LIST,(long)self.reviewType] 
         withParaments:nil 
      withSuccessBlock:^(id response) {
         // weakSelf.pageModel= [PageModel modelWithDictionary:response];
          weakSelf.bookings = [NSMutableArray array];
          
          NSArray *array = (NSArray *)response;
          for (NSDictionary *dic in array) {
              
              BookingModel *item = [BookingModel modelWithDictionary:dic];
              item.shareAddress = dic[@"address"];
              item.shareIcon = dic[@"shareIcons"];
              [weakSelf.bookings addObject:item];
          } 
          
          if (weakSelf.bookings.count) {
              weakSelf.tableView.tableHeaderView = [UIView new];
              
          }else{
              weakSelf.tableView.tableHeaderView = self.headerView;
          }
          [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
          [weakSelf dismiss]; 
      } withFailureBlock:^(NSString *error) {
          
          [weakSelf dismiss];
      }];
}
 

- (void)requestReviewList{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:[NSString stringWithFormat:@"%@%ld?page=%d&size=50",API_REVIEW_OTHER,(long)self.reviewType,0] 
         withParaments:nil 
      withSuccessBlock:^(id response) {
          weakSelf.pageModel= [PageModel modelWithDictionary:response];
          weakSelf.dataSource = [NSMutableArray array];
          [weakSelf.dataSource addObjectsFromArray:self.pageModel.content];
         // [weakSelf.tableView reloadData];
          [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
          
          [weakSelf dismiss];
      }withFailureBlock:^(NSString *error) {
          
          [weakSelf dismiss];
      }];
}

- (void)dismiss{
    _requestCount ++;
    
    [self.refreshControl endRefreshing];

    if (_requestCount == 2) {
        [SVProgressHUD dismiss];   
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }
    return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_bookings.count==0 && section==0) {
        return 0;
    }
    return 80;
}
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section) {
//        return @"Past Reviews You’ve Written";
//    }
//    return @"Reviews to Write";
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 80)];
    vi.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, TX_SCREEN_WIDTH-40, 80)];
    label.textColor = TX_COLOR_FROM_RGB(0x646464);
    label.font = TX_FONT(25);
    if (section) {
        label.text = @"Past Reviews You’ve Written";
    }else{
        if (_bookings.count==0) {
            return nil;
        }
        label.text = @"Reviews to Write";
    }
    [vi addSubview:label];
    return vi;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return _bookings.count;//>0?1:0;
    }
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        PastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"past" forIndexPath:indexPath];
        
        // Configure the cell...        
        cell.row = indexPath.row;
        BookingModel *booking = self.bookings[indexPath.row];
        [cell.userIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(booking.thumbnail)] 
                      placeholderImage:kDEFAULT_IMAGE];
        cell.lbCaretype.text = booking.careType.integerValue==0?@"EleCare":(booking.careType.integerValue==1?@"Babysitting":@"Events");
        // cell.lbDate
        cell.lbAddress.text = booking.shareAddress;
        [cell configStartDate:booking.startDate endDate:booking.endDate]; 
        return cell;
    }else{
        ReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCell" forIndexPath:indexPath];
        //  cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        NSDictionary *dic = self.dataSource[indexPath.row];
        [cell configIcon:dic[@"userIcon"] 
                userName:dic[@"userName"] 
                    time:dic[@"createTime"] 
                 content:dic[@"experience"]];
        cell.reportBtn.hidden = YES;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        _selectRow = indexPath.row;
        BookingModel *item = self.bookings[indexPath.row];
        BookingReviewVC *create  = [[BookingReviewVC alloc] init];
        create.booking = item;
        create.bookingId = item.bookingId;
        create.delegate = self;
        [self.navigationController pushViewController:create animated:YES];
    }
}

- (void)addReviewWith:(BookingModel *)booking{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectRow inSection:0];
    [self.bookings removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    self.tableView.tableHeaderView = self.bookings.count?[UIView new]:self.headerView;
    
    
    [self requestReviewList];
}

 

@end


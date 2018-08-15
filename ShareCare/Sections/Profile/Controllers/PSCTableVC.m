//
//  PSCTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PSCTableVC.h"

@interface PSCTableVC ()

@end

@implementation PSCTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_WHITE;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UpcomingCell  class]) bundle:nil] forCellReuseIdentifier:@"upcoming"];
}
- (UIView *)headerView{
    if (!_headerView) { 
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 150)];
        
        _headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, TX_SCREEN_WIDTH-60, 40)];
        _headerTitleLabel.textColor = TX_RGB(100, 100, 100);
        _headerTitleLabel.font = TX_BOLD_FONT(20);
        _headerTitleLabel.text = [self headerTitleText];
        [_headerView addSubview:_headerTitleLabel];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, TX_SCREEN_WIDTH-60, 90)];
        descLabel.textColor = COLOR_GRAY;
        descLabel.font = TX_FONT(15);
        descLabel.numberOfLines = 0;
        descLabel.text = [self headerDescText];
        [_headerView addSubview:descLabel]; 
    }
    return _headerView;
    
}
- (UIView *)footerView{
    if (!_footerView) { 
     
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 80*TX_SCREEN_OFFSET)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton *postBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320*TX_SCREEN_OFFSET, 52*TX_SCREEN_OFFSET)];
        postBtn.center = CGPointMake(TX_SCREEN_WIDTH/2.0, 40); 
        [postBtn setImage:[UIImage imageNamed:@"post-a-new-listing"] forState:UIControlStateNormal];
        [postBtn addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:postBtn]; 
        
    }
    return _footerView;
    
}
- (NSString *)headerTitleText{
    return @"";
}
- (NSString *)headerDescText{
    return @"";
}
- (id)convertObjectWithObject:(id)object{
//    BookingModel *model =[BookingModel modelWithDictionary:object];
//    model.bookingStatus=@"2";
//    return model;
    return [BookingModel modelWithDictionary:object];
}
- (void)post:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

@end

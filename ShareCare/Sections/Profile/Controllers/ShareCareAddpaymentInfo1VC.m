//
//  ShareCareAddpaymentInfo1VC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareCareAddpaymentInfo1VC.h"
#import "AddPaypalmethodVC.h"
#import "AddBankTransferVC.h"

@interface ShareCareAddpaymentInfo1VC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btNext;
@property (weak, nonatomic) IBOutlet UIButton *btPaypal;
@property (weak, nonatomic) IBOutlet UIButton *btBankTransfer;

@end

@implementation ShareCareAddpaymentInfo1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize =CGSizeMake(TX_SCREEN_WIDTH, 750*TX_SCREEN_OFFSET);
    self.automaticallyAdjustsScrollViewInsets = NO; 
    
//    if (_card.cardType.length) {
//        if (_card.cardType.integerValue == 3) {
//            _btBankTransfer.selected = NO;
//            _btPaypal.selected = YES;
//            AddPaypalmethodVC *detail = [[AddPaypalmethodVC alloc] init];
//            detail.card = _card;
//            detail.isEdit = self.isEdit;
//            [self.navigationController pushViewController:detail animated:NO];
//        }else if (_card.cardType.integerValue == 0) {
//            _btBankTransfer.selected = YES;
//            _btPaypal.selected = NO;
//            AddBankTransferVC *detail = [[AddBankTransferVC alloc] init];
//            detail.card = _card;
//            detail.isEdit = self.isEdit;
//            [self.navigationController pushViewController:detail animated:NO];
//        }
//        
//        _btNext.enabled = self.isEdit;
//    }
}
- (IBAction)payPal:(UIButton *)sender {
    sender.selected = YES;
    _btNext.enabled = YES;
    _btBankTransfer.selected = NO; 
    
    _card.cardType = @"2";
    [self next:nil];
}
- (IBAction)bankTransfer:(UIButton *)sender {
    sender.selected = YES;
    _btNext.enabled = YES;
    _btPaypal.selected = NO;
    
    _card.cardType = @"1";
    
    [self next:nil];
}
- (IBAction)next:(id)sender {
    if (_btPaypal.selected) {
        AddPaypalmethodVC *detail = [[AddPaypalmethodVC alloc] init];
        detail.card = _card;
        detail.isEdit = self.isEdit;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        AddBankTransferVC *detail = [[AddBankTransferVC alloc] init];
        detail.card = _card;
        detail.isEdit = self.isEdit;
        [self.navigationController pushViewController:detail animated:YES];
    }
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

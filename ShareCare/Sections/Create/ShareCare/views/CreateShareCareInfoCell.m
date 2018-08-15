//
//  CreateShareCareInfoCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CreateShareCareInfoCell.h"

@implementation CreateShareCareInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _childrens = 1;
    _tfPerday.delegate = self;
    _tfPhotoCount.delegate = self;
    
 //   [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"location"];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
    [self setDataSource:@[]];
 //   _tableView.tableFooterView = [UIView new];
    
    _ages = [NSMutableDictionary dictionaryWithDictionary:@{@"age0_1":@0,
                                                            @"age1_2":@0,
                                                            @"age2_3":@0,
                                                            @"age3_5":@0,
                                                            @"age5+":@0
                                                            }];
    
    _credentials = [NSMutableDictionary dictionaryWithDictionary:@{@"nonsmoker":@0,
                                                                   @"drivers":@0,
                                                                   @"havecar":@0,
                                                                   @"cleaning":@0,
                                                                   @"anphylaxis":@0,
                                                                   @"firstaid":@0,
                                                                   @"cooking":@0,
                                                                   @"tutoring":@0
                                                                   }];
    _ageRangeModel = [[AgeRangeModel alloc] init];
    _credentialsModel = [[CredentialsModel alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editAbout:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    _editAboutBlock();
}

- (IBAction)childrenSelected:(UIButton *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    for (UIButton *button in _checkBtns) {
        button.selected = NO;
    }
    sender.selected = YES;
    _childrens = [[sender titleLabel].text integerValue];
}
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.text = _lbAddress.text;
//    _lbAddress.hidden = YES; 
//    _addressEditStateBlock(YES);
//}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    _lbAddress.text = textField.text;
//    _lbAddress.hidden = NO;
//    textField.text = @"";
//    _tableView.hidden=  YES;
//    _addressEditStateBlock(NO);
//} 
//- (IBAction)textFieldEditingChanged:(UITextField *)textField {
//    _addressBlock(textField.text);
//}
- (IBAction)selectedAgesAciton:(UIButton *)sender {
    
    //多选
    sender.selected = !sender.selected; 
    switch (sender.tag) {
        case 0:
            _ageRangeModel.age0_1 = sender.selected;
            break;
        case 1:
            _ageRangeModel.age1_2 = sender.selected;
            break;
        case 2:
            _ageRangeModel.age2_3 = sender.selected;
            break;
        case 3:
            _ageRangeModel.age3_5 = sender.selected;
            break;
        case 4:
            _ageRangeModel.age5 = sender.selected;
            break;
            
        default:
            break;
    }
}
- (IBAction)selectedCredentialsAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 0: 
            _credentialsModel.nonsmoker = sender.selected;
            break;
        case 1:
            _credentialsModel.drivers = sender.selected;
            break;
        case 2:
            _credentialsModel.havecar = sender.selected;
            break;
        case 3:
            _credentialsModel.cleaning = sender.selected;
            break;
        case 4:
            _credentialsModel.anphylaxis = sender.selected;
            break;
        case 5:
            _credentialsModel.firstaid = sender.selected;
            break;
        case 6:
            _credentialsModel.cooking = sender.selected;
            break; 
        case 7:
            _credentialsModel.tutoring = sender.selected;
            break; 
            
        default:
            break;
    }
}

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    self.tableView.hidden = !(_dataSource.count);  
    [self.tableView reloadData];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _tfPerday) {
    if (([string isEqualToString:@"."]||[string isEqualToString:@"0"]) && [textField.text isEqualToString:@""]) {
        textField.text = @"0.";
        return NO;
    }
        
        if ([string isEqualToString:@"."] && [textField.text containsString:@"."]) {
            return NO;
        }
    NSRange myRange = [textField.text rangeOfString:@"."];
    if (myRange.length != 0) {
        if ([textField.text length]-myRange.location >= 3) {
            if ([string isEqualToString:@""]) {
                return YES;
            }else {
                return NO;
            }
        }else {
            return YES;
        }
    }if(textField.text.length>4 && string.length>0){
        return NO;
    }else {
        return YES;
    }
        
    }else{
        
        if ([string isEqualToString:@"0"] && [textField.text isEqualToString:@""]) {
            textField.text = @"";
            return NO;
        }
        
        if(textField.text.length>1 && string.length>0){
            return NO;
        }else {
            return YES;
        }
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellId = @"place_cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];   
        cell.textLabel.font = TX_BOLD_FONT(16);
        cell.detailTextLabel.font = TX_FONT(13);
        cell.detailTextLabel.numberOfLines = 2;
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    cell.textLabel.text = dict[@"PrimaryText"];
    cell.detailTextLabel.text = dict[@"FullText"]; 
    cell.imageView.image = [UIImage imageNamed:@"location-icon-blue"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    _tfAddress.text = dict[@"FullText"];
    
    [self setDataSource:@[]];
}
- (IBAction)addressDetail:(id)sender {
    _addressBlock(nil);
}
@end

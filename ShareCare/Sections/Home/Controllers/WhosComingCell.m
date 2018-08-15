//
//  WhosComingCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "WhosComingCell.h"

@implementation WhosComingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgheader.layer.masksToBounds = YES;
    _imgheader.layer.cornerRadius = CGRectGetWidth(_imgheader.frame)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChild:(ChildrenModel *)child{
    _child = child;
    
    _isMyChildren = child.isMyChild; 
    _imgheader.hidden = !child.isMyChild;
    _icon.hidden = child.isMyChild;
    _minBtn.hidden = !child.isMyChild;
    
    _isBoy = [child.gender isEqualToString:@"Male"];
    _lbAge.textColor = _isBoy?COLOR_BLUE:COLOR_PINK;
    _lbStatus.textColor = _isBoy?COLOR_BLUE:COLOR_PINK;
    _icon.highlighted = !_isBoy;
    
    _state = child.state;
    _lbStatus.text = child.stateStr;
    if (_state == ChildStateBusy ||_state == ChildStateCheckAgeRange) {  
        _lbAge.textColor = COLOR_GRAY;
        _lbStatus.textColor = COLOR_GRAY;
    } 
    if (_isMyChildren) {
        [_imgheader setImageWithURL:[NSURL URLWithString:URLStringForPath(child.childIconPath)] 
                   placeholderImage:kDEFAULT_HEAD_IMAGE];
        _lbAge.text = child.fullName;
    }else{
        _lbAge.text= child.age.length?child.age:child.fullName;
    }
    
    
}  
 

- (IBAction)minuClick:(id)sender {
    if (_deleteBlock) {
        _deleteBlock();
    } 
}

@end

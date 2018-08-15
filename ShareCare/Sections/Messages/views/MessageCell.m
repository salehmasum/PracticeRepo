//
//  MessageCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MessageCell.h"
#import "UIImage+Rotate.h"

@interface MessageCell(){
}
@property (strong,nonatomic) UIActivityIndicatorView *loadImageActivity;
@end

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (UIActivityIndicatorView *)loadImageActivity{
    if (_loadImageActivity) {
        _loadImageActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadImageActivity.hidesWhenStopped = YES;
        [self addSubview:_loadImageActivity];
    }
    return _loadImageActivity;
}

- (void)layoutSubviews{
    
    UIImage *image =_backgroundImageView.image;
    UIImage*newImage ;//= [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    
    // 四个数值对应图片中距离上、左、下、右边界的不拉伸部分的范围宽度
    newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 45, 25, 25) resizingMode:UIImageResizingModeStretch];
    
    _backgroundImageView.image = newImage;
    
}

- (void)resetImage{
    
}

- (void)setMessage:(MessageModel *)message{
    _message = message;
    
    
    if (message.type == MessageTypeTEXT) {
        CGRect rect = _backgroundImageView.frame;
        CGRect lbRect = _lbContent.frame;
        int strLength = [self textLength:message.content];
//        if (strLength<16) {
//            rect.size.width = strLength*12>100?strLength*12:100;//(213*TX_SCREEN_OFFSET)/2.0+20;
//            rect.origin.x = 15;
//            
//            lbRect.size.width = rect.size.width;//(181*TX_SCREEN_OFFSET)/2.0+20;
//            lbRect.origin.x = 33;
//            _lbContent.textAlignment = NSTextAlignmentCenter;
//        }else{
//            rect.size.width = (213*TX_SCREEN_OFFSET);
//            rect.origin.x = 15;
//            
//            lbRect.size.width = rect.size.width;
//            lbRect.origin.x = 33;
//            _lbContent.textAlignment = NSTextAlignmentLeft;
//        }
        
        CGFloat textWidth = 9;
        if (strLength*textWidth<100) {
            rect.size.width = 100;
            _lbContent.textAlignment = NSTextAlignmentCenter;
            lbRect.size.width = rect.size.width;
        }else if (strLength*textWidth>213*TX_SCREEN_OFFSET) {
            rect.size.width = (213*TX_SCREEN_OFFSET);
            _lbContent.textAlignment = NSTextAlignmentLeft;
            lbRect.size.width = rect.size.width-30;
        }else{
            rect.size.width = strLength*textWidth+20;
            lbRect.size.width = rect.size.width-30;
        }
        
        rect.origin.x = 15;
        
        lbRect.origin.x = 33;
       // _lbContent.textAlignment = NSTextAlignmentLeft;
        
        _backgroundImageView.frame = rect;
        _lbContent.frame = lbRect;
    }else{
        CGRect rect = _backgroundImageView.frame;
        CGRect lbRect = _lbContent.frame;
        rect.size.width = (213*TX_SCREEN_OFFSET);
        lbRect.size.width = (181*TX_SCREEN_OFFSET);
        rect.origin.x = 15;
        lbRect.origin.x = 33;
        
        _lbContent.textAlignment = NSTextAlignmentLeft;
        _backgroundImageView.frame = rect;
        _lbContent.frame = lbRect;
    }
    _lbContent.hidden = (_message.type!=MessageTypeTEXT);
    CGPoint center = _backgroundImageView.center;
    if (center.x>TX_SCREEN_WIDTH/2.0) {
        center.x = TX_SCREEN_WIDTH-center.x;
    }
    if (message.isFromSelf) {
        _backgroundImageView.center = CGPointMake(TX_SCREEN_WIDTH-center.x, center.y);
        UIImage *image = [UIImage imageNamed:@"chat-message-right"];
        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        _backgroundImageView.image = image;
        [self resetImage];
        _activityView.center = CGPointMake(CGRectGetMinX(_backgroundImageView.frame)-20, _backgroundImageView.center.y);
        
        _btnResend.frame = CGRectMake(CGRectGetMaxX(_activityView.frame)-100, _activityView.center.y-20, 100, 40);
        _btnResend.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        
        _lbContent.center = _backgroundImageView.center;
        _lbContent.textColor = [UIColor whiteColor];
        _msgImageView.center = _backgroundImageView.center;
        
    }else{
        _backgroundImageView.center = CGPointMake(center.x, center.y);
        UIImage *image = [UIImage imageNamed:@"chat-message-left"];
        image = [image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        _backgroundImageView.image = image;
        _activityView.center = CGPointMake(CGRectGetMaxX(_backgroundImageView.frame)+20, _backgroundImageView.center.y);
        
        _btnResend.frame = CGRectMake(CGRectGetMinX(_activityView.frame), _activityView.center.y-20, 100, 40);
        _btnResend.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
        _lbContent.center = CGPointMake(_backgroundImageView.center.x+5, _backgroundImageView.center.y);
        _lbContent.textColor = [UIColor blackColor];
        _msgImageView.center = _backgroundImageView.center;
    }
    
    
    if (message.type == MessageTypeTEXT) {
        _lbContent.text = message.content;
        _msgImageView.hidden = YES;
        _backgroundImageView.hidden = NO;
    }else if (message.type == MessageTypePICTURE){
        _msgImageView.layer.masksToBounds = YES;
        _msgImageView.layer.cornerRadius = 16;
        _msgImageView.layer.borderColor = TX_RGB(240, 240, 240).CGColor;
        _msgImageView.layer.borderWidth = 1;
        _msgImageView.hidden = NO;
        _backgroundImageView.hidden = YES;
        if (![message.content containsString:@"/"]) { 
            NSString *imagePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",message.content]];
            _msgImageView.image = [UIImage imageWithContentsOfFile:imagePath];
        }else{
            [_msgImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(message.content)] 
                          placeholderImage:kDEFAULT_IMAGE]; 
            self.loadImageActivity.center = CGPointMake(_msgImageView.center.x, _msgImageView.center.y+40);
 //           [self.loadImageActivity startAnimating];
//            [_msgImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLStringForPath(message.content)]] placeholderImage:kDEFAULT_IMAGE success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//                _msgImageView.image = image;
//                [_msgImageView setNeedsDisplay]; 
//                
//                [self.loadImageActivity stopAnimating];
//            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//                
//                [self.loadImageActivity stopAnimating];
//            }];
        }
       
        _lbContent.text = @"";
    }
}

- (void)setSendState:(SendMessageState)sendState{
    _sendState = sendState;
    
    
    switch (sendState) {
        case SendMessageStateLoading:
            [self.activityView startAnimating];
            _btnResend.hidden = YES;
            break;
        case SendMessageStateSuccess:
            [self.activityView stopAnimating];
            _btnResend.hidden = YES;
            break;
        case SendMessageStateFaild:
            [self.activityView stopAnimating];
            _btnResend.hidden = NO;
            break;
            
        default:
            break;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)reSend:(id)sender {
    
    _btnResend.hidden = YES;
    if (_reSendBlock) {
        _reSendBlock(_message);
    }
}

-(int)textLength:(NSString *)str { 
    int strlength = 0;
    for(int i=0; i< [str length];i++){ 
        int a = [str characterAtIndex:i]; 
        if( a > 0x4e00 && a < 0x9fff)
        { 
            strlength += 2;
        }else{
            strlength ++;
        }
    } 
    return strlength;
}
@end

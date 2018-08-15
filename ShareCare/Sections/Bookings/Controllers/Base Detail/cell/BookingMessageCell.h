//
//  BookingMessageCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BookingMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (weak, nonatomic) IBOutlet UIImageView *imgheader;

@property (strong, nonatomic) NSString *userName;
@property (assign, nonatomic) id<ContactSharecarerDelegate>delegate;
@end

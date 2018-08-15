//
//  UIViewController+AddressBook.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AddressBookBlock)(NSString *name,NSString *phone);

@interface UIViewController (AddressBook)
- (void)showAddressBookSelected:(AddressBookBlock)contact;
@end

//
//  EditChildrenVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+XHPhoto.h"
#import "ChildrenModel.h"
@interface EditChildrenVC : UIViewController

typedef void(^EditChildBlock)(ChildrenModel *child);

@property (strong, nonatomic) ChildrenModel *child;
@property (strong, nonatomic) EditChildBlock childBlock;

@end

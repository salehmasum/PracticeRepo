//
//  NavigationMenuView.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NavigationMenuView.h"


#define INPUT_VIEW_HEIGHT 40*TX_SCREEN_OFFSET
#define INPUT_VIEW_SPACE  5
#define IMAGE_SIZE 24

@interface NavigationMenuView (){
    UILabel *_line; 
    
    UIImageView *backgroundImageView;
    
    BackActionBlock _backBlock;
}
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UIView *locationView;
@property (strong, nonatomic) UIView *typeView;
@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation NavigationMenuView

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if (backgroundImageView) { 
        backgroundImageView.frame = CGRectMake(0, -TX_SCREEN_HEIGHT+frame.size.height, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT);
    }
}
 

 
- (instancetype)initWithType:(MenuType)type{
    if (self = [super init]) {
          
    }
    return self;
}
 

- (void)setType:(MenuType)type{
    if (type == MenuTypeSearch) {
        self.frame = CGRectMake(0, 24*iSiPhoneX, TX_SCREEN_HEIGHT, NAVIGATION_SEARCH_MENU_HEIGHT);  
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -TX_SCREEN_HEIGHT+self.frame.size.height+24*iSiPhoneX, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT)];
        backgroundImageView.image = [UIImage imageNamed:@"background-image"];
        [self addSubview:backgroundImageView];
        [self addSubview:self.locationView];
        [self addSubview:self.typeView];
        [self addSubview:self.timeView]; 
        [self addSubview:self.closeBtn]; 
        [self addSubview:self.searchView];
        
        
        
        
        
        self.locationView.alpha = 0;
        self.typeView.alpha = 0;
        self.timeView.alpha = 0;
        self.closeBtn.alpha = 0;
        
        [self sendSubviewToBack:backgroundImageView];
        
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin; 
        
    }else if(type == MenuTypeNav){ 
        self.frame = CGRectMake(0, 24*iSiPhoneX, TX_SCREEN_HEIGHT, NAVIGATION_MENU_HEIGHT);  
        self.titleLabel.font = TX_BOLD_FONT(35);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel]; 
    }else if(type == MenuTypePushView){ 
        self.frame = CGRectMake(0,24*iSiPhoneX, TX_SCREEN_HEIGHT, NAVIGATION_MENU_HEIGHT);  
        self.titleLabel.font = TX_FONT(18);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = COLOR_GRAY;
        [self addSubview:self.titleLabel]; 
    }
    
    [self addSubview:self.menuView];

}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, TX_SCREEN_WIDTH-40, 44)];
        
        [self addSubview:_titleLabel]; 
    }
    return _titleLabel;
}
- (void)setBackImage:(UIImage *)image action:(BackActionBlock)backBlock{
    _backBlock = backBlock;
    [self.backButton setImage:image forState:UIControlStateNormal];
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(-20, 20, 84, 44)]; 
        [_backButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (void)clickBack{
    _backBlock();
}



- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
}

- (void)setTitleColor:(UIColor *)titleColor{
    
    self.titleLabel.textColor = titleColor;
}
- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = [NSArray arrayWithArray:dataSource];
    
    CGFloat width = TX_SCREEN_WIDTH/_dataSource.count;
     
    self.shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.menuView.frame)-8*TX_SCREEN_OFFSET-24*iSiPhoneX, TX_SCREEN_WIDTH, 10)];
    self.shadowView.image = [UIImage imageNamed:@"shadow_line_down"];
    [self.menuView addSubview:self.shadowView];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(7, 23, width>(TX_SCREEN_WIDTH/4-10)?(TX_SCREEN_WIDTH/4-10):width, 3)];
    _line.backgroundColor = self.textColor;
    [self.menuView addSubview:_line];
    _line.center = CGPointMake(width/2, _line.center.y);
    
    
    CGFloat start_x = 0;
    CGFloat btnWidth = width;
    
    NSMutableString *string = [NSMutableString string];
    for (NSInteger index = 0; index<_dataSource.count; index++) {
        [string appendString:_dataSource[index]];
    }
  //  CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TX_BOLD_FONT(15),NSFontAttributeName,nil]]; 
 //   CGFloat scale = TX_SCREEN_WIDTH/size.width;
    
    for (NSInteger index = 0; index<_dataSource.count; index++) {
        
        NSString *text = _dataSource[index];
        
      //  CGSize textSize = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TX_BOLD_FONT(15),NSFontAttributeName,nil]]; 
        
        if (_dataSource.count >= 4) {
            btnWidth =  text.length==3?60:btnWidth; 
         //   btnWidth = textSize.width*scale;
        }
        
        
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = CGRectMake(start_x, 0, btnWidth, 30);
        [menu setTitle:text forState:UIControlStateNormal];
        menu.titleLabel.font = TX_BOLD_FONT(14);
        [menu setTitleColor:self.textColor forState:UIControlStateNormal];
        [menu addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        menu.tag = index;
        [self.menuView addSubview:menu];
        
         
        start_x += btnWidth;
        btnWidth = (TX_SCREEN_WIDTH-(start_x))/(_dataSource.count-index-1);
        
        if (index==0) { 
            [self resetLineCenterFor:menu];
        }
    }
    
}

- (UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-30, TX_SCREEN_WIDTH, 30)];
    }
    
    return _menuView;
}
 
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake( 20*TX_SCREEN_OFFSET, 35*TX_SCREEN_OFFSET, 40*TX_SCREEN_OFFSET, 40*TX_SCREEN_OFFSET); 
        [_closeBtn setImage:[UIImage imageNamed:@"home_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside]; 

    }
    return _closeBtn;
}

- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(20*TX_SCREEN_OFFSET, 35*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH-20*TX_SCREEN_OFFSET, INPUT_VIEW_HEIGHT)];
    //    _searchView.backgroundColor = [UIColor redColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_searchView.bounds)-36, CGRectGetHeight(_searchView.bounds))];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.alpha = 0.3;
        [_searchView addSubview:imageView];
        
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 24*TX_SCREEN_OFFSET, 24*TX_SCREEN_OFFSET)];
        icon.image = [UIImage imageNamed:@"search"];
        [_searchView addSubview:icon];
        
        _searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, CGRectGetWidth(_searchView.frame)-70, INPUT_VIEW_HEIGHT-10)];
        _searchLabel.textColor = COLOR_WHITE;
        _searchLabel.font = TX_BOLD_FONT(16);
        _searchLabel.text = @"Nearby · Popular · Anytime";
        [_searchView addSubview:_searchLabel]; 
        
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _searchView.bounds;
        btn.tag = 0;
        [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:btn];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( 0, 0, 30*TX_SCREEN_OFFSET, 30*TX_SCREEN_OFFSET);
        button.center = CGPointMake(CGRectGetMaxX(imageView.frame)+18, _searchView.frame.size.height/2);
        [button setImage:[UIImage imageNamed:@"plus-event"] forState:UIControlStateNormal]; 
        [button addTarget:self action:@selector(addSomeoneList:) forControlEvents:UIControlEventTouchUpInside];
        [_searchView addSubview:button];
        
      //  _searchView.frame = CGRectMake(20, 35, TX_SCREEN_WIDTH-20, INPUT_VIEW_HEIGHT);
    }
    
    return _searchView;
}


- (UIView *)locationView{
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(28, CGRectGetMinY(self.searchView.frame), TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_locationView.bounds];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.alpha = 0.3;
        [_locationView addSubview:imageView];
        
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        icon.image = [UIImage imageNamed:@"search_location"];
        icon.contentMode =UIViewContentModeScaleAspectFit;
        icon.center = CGPointMake(IMAGE_SIZE/2+10, INPUT_VIEW_HEIGHT/2);
        [_locationView addSubview:icon];
        
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, CGRectGetWidth(_locationView.frame)-50, INPUT_VIEW_HEIGHT-10)];
        _locationLabel.textColor = COLOR_WHITE;
        _locationLabel.font = TX_BOLD_FONT(18);
        _locationLabel.text = @"Nearby";
        [_locationView addSubview:_locationLabel]; 
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _locationView.bounds; 
        btn.tag = 1;
        [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_locationView addSubview:btn];
        
    }
    
    return _locationView;
}
- (UIView *)typeView{
    if (!_typeView) {
        _typeView = [[UIView alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(self.locationView.frame)+5, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_typeView.bounds];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.alpha = 0.3;
        [_typeView addSubview:imageView];
        
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        icon.image = [UIImage imageNamed:@"search_elephant-white"];
        icon.contentMode =UIViewContentModeScaleAspectFit;
        icon.center = CGPointMake(IMAGE_SIZE/2+10, INPUT_VIEW_HEIGHT/2);
        [_typeView addSubview:icon];
        
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, CGRectGetWidth(_typeView.frame)-50, INPUT_VIEW_HEIGHT-10)];
        _typeLabel.textColor = COLOR_WHITE;
        _typeLabel.font = TX_BOLD_FONT(18);
        _typeLabel.text = @"Popular";
        [_typeView addSubview:_typeLabel]; 
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _typeView.bounds; 
        btn.tag = 2;
        [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_typeView addSubview:btn];
        
    }
    
    return _typeView;
}
- (UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(self.typeView.frame)+5, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_timeView.bounds];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.alpha = 0.3;
        [_timeView addSubview:imageView];
        
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_SIZE, IMAGE_SIZE)];
        icon.image = [UIImage imageNamed:@"search_calendar"];
        icon.contentMode =UIViewContentModeScaleAspectFit;
        icon.center = CGPointMake(IMAGE_SIZE/2+10, INPUT_VIEW_HEIGHT/2);
        [_timeView addSubview:icon];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, CGRectGetWidth(_timeView.frame)-50, INPUT_VIEW_HEIGHT-10)];
        _timeLabel.textColor = COLOR_WHITE;
        _timeLabel.font = TX_BOLD_FONT(18);
        _timeLabel.text = @"Anytime";
        [_timeView addSubview:_timeLabel]; 
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = _timeView.bounds; 
        btn.tag = 3;
        [btn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [_timeView addSubview:btn];
        
    }
    
    return _timeView;
}

- (void)searchAction:(UIButton *)button{
    //
    
    switch (button.tag) {
        case 0:{ 
            [self openAction:nil];            
            
        }
            
            break;
        case 1:
            NSLog(@"Do something 1");
            [_delegate navigaitonMenuDidSelectedItemType:MenuSelectedItemTypeLocation];
            break;
        case 2:
            NSLog(@"Do something 2");
            [_delegate navigaitonMenuDidSelectedItemType:MenuSelectedItemTypeCategory];
            break;
        case 3:
            NSLog(@"Do something 3");
            [_delegate navigaitonMenuDidSelectedItemType:MenuSelectedItemTypeCalendar];
            break;
            
        default:
            break;
    }
    
    
}

- (void)openAction:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(navigaitonMenuDidChangeStatus:)]) {
        [_delegate navigaitonMenuDidChangeStatus:YES];
    }
    
    [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION animations:^{
        self.searchView.alpha = 0;
        self.locationView.alpha = 1;
        self.typeView.alpha = 1;
        self.timeView.alpha = 1;
        self.menuView.alpha = 0;
        self.closeBtn.alpha = 1;
         
        
    }];
    
    [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION animations:^{
        self.locationView.frame = CGRectMake(28, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*1, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);
        self.typeView.frame = CGRectMake(28, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*2, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);;
        self.timeView.frame = CGRectMake(28, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*3, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);; 
    }];

}


- (void)closeAction:(id)sender{
     
    if (_delegate && [_delegate respondsToSelector:@selector(navigaitonMenuDidChangeStatus:)]) {
        [_delegate navigaitonMenuDidChangeStatus:NO];
    }
    
    [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION animations:^{
        self.searchView.alpha = 1;
        self.locationView.alpha = 0;
        self.typeView.alpha = 0;
        self.timeView.alpha = 0;
        self.menuView.alpha = 1;
        self.closeBtn.alpha = 0;   
    }];
    
    [UIView animateWithDuration:NAVIGATION_MENU_ANIMATION_DURATION animations:^{
        self.locationView.frame = CGRectMake(28, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*0, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);
        self.typeView.frame = CGRectMake(28, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*1, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);;
        self.timeView.frame = CGRectMake(28, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*2, TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);; 
  //      backgroundImageView.frame = CGRectMake(0, -TX_SCREEN_HEIGHT+NAVIGATION_MENU_HEIGHT, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT);
    }];
    
}

- (void)onButton:(UIButton *)button{
    

    [self resetLineCenterFor:button];
    
    [_delegate navigaitonMenudidSelectedAtIndex:button.tag];
}

- (void)resetLineCenterFor:(UIButton *)button{
    CGRect rect = _line.frame; 
    NSInteger length = [button.titleLabel.text length];
    length = length>=5?length:5;
    
    CGSize size = [button.titleLabel.text sizeWithAttributes:nil];  
    
    rect.size.width = size.width+15;//length*10*TX_SCREEN_OFFSET;
    _line.frame = rect;
    _line.center = CGPointMake(button.center.x, _line.center.y);
}

- (void)setOffset:(CGFloat)offset{
    _offset = offset; 
    
    CGFloat scale = offset/CONDITION_VIEW_HEIGHT;
     
    
    self.searchView.alpha = scale;
    self.locationView.alpha = 1-scale;
    self.typeView.alpha = 1-scale;
    self.timeView.alpha = 1-scale;
    self.menuView.alpha = scale;
    self.closeBtn.alpha = 1-scale;  
    
    
    //open
    self.locationView.frame = CGRectMake(20, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*(1-scale), TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);
    self.typeView.frame = CGRectMake(20, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*(2-scale), TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);;
    self.timeView.frame = CGRectMake(20, CGRectGetMinY(self.searchView.frame)+(INPUT_VIEW_HEIGHT+INPUT_VIEW_SPACE)*(3-scale), TX_SCREEN_WIDTH-56, INPUT_VIEW_HEIGHT);
    
  
}

- (void)addSomeoneList:(UIButton *)sender{
    [_delegate navigaitonMenuAddListAction];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

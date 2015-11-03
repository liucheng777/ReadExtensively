//
//  MainTabBarController.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//


#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "Common.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
#import "AppDelegate.h"
#import "ThemeImageView.h"
#import "ThemeLable.h"

@interface MainTabBarController ()
{
    ThemeImageView *_selectedImageView;
    ThemeImageView *_badgeImageView;
    ThemeLable *_badgeLable;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createSubControllers];
    [self _createTabBar];
    
    [NSTimer scheduledTimerWithTimeInterval:10000 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)_createTabBar
{
    //01删除tabarButton
    for (UIView *view in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    //02设置背景图片
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
//    bgImageView.image = [UIImage imageNamed:@"Skins/cat/mask_navbar.png"];
    bgImageView.imageName = @"mask_navbar.png";
    [self.tabBar addSubview:bgImageView];
    
    //03选中图片
    CGFloat width = kScreenWidth / 5;
    _selectedImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, width, 49)];
//    _selectedImageView.image = [UIImage imageNamed:@"Skins/cat/home_bottom_tab_arrow.png"];
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
    [self.tabBar addSubview:_selectedImageView];
    
    //04设置 按钮
//    NSArray *imageNames = @[@"Skins/cat/home_tab_icon_1.png",
//                            @"Skins/cat/home_tab_icon_2.png",
//                            @"Skins/cat/home_tab_icon_3.png",
//                            @"Skins/cat/home_tab_icon_4.png",
//                            @"Skins/cat/home_tab_icon_5.png"];
    
    NSArray *imageNames = @[@"home_tab_icon_1.png",
                            @"home_tab_icon_2.png",
                            @"home_tab_icon_3.png",
                            @"home_tab_icon_4.png",
                            @"home_tab_icon_5.png"];
    for (int i = 0; i < 5; i++) {
        ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(width * i, 0, width, 49)];
//        [button setImage:[UIImage imageNamed:imageNames[i]] forState:UIControlStateNormal];
        button.normalImageName = imageNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
}
-(void)selectAction:(UIButton *)button
{
    [UIView animateWithDuration:.2 animations:^{
        _selectedImageView.center = button.center;
    }];
    self.selectedIndex = button.tag;
    
}

-(void)_createSubControllers
{
    NSArray *names = @[@"Home",@"Message",@"Discover",@"Profile",@"More"];
    NSMutableArray *navArray = [[NSMutableArray alloc]initWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        BaseNavigationController *nav = [storyBoard instantiateInitialViewController];
        [navArray addObject:nav];
    }
    self.viewControllers = navArray;
}
-(void)timerAction:(NSTimer *)timer
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:unread_count
                       params:nil
                   httpMethod:@"GET"
                     delegate:self];
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    CGFloat buttonWidth = kScreenWidth / 5;
    if (_badgeImageView == nil) {
        _badgeImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(buttonWidth - 32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeImageView];
        
        
        _badgeLable = [[ThemeLable alloc]initWithFrame:_badgeImageView.bounds];
        _badgeLable.backgroundColor = [UIColor clearColor];
        _badgeLable.colorName = @"Timeline_Notice_color";
        _badgeLable.textAlignment = NSTextAlignmentCenter;
        _badgeLable.font = [UIFont systemFontOfSize:13];
        [_badgeImageView addSubview:_badgeLable];
    }
    if (count == 0) {
        _badgeImageView.hidden = YES;
    }
    else if (count > 99)
    {
        _badgeImageView.hidden = NO;
        _badgeLable.text = @"99";
    }
    else
    {
        _badgeImageView.hidden = NO;
        _badgeLable.text = [NSString stringWithFormat:@"%li",count];
    }
    
}
@end

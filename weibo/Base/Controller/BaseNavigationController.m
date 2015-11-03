//
//  BaseNavigationController.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _loadImage];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNameDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}
-(void)themeNameDidChange:(NSNotification *)notification
{
    [self _loadImage];
}
-(void)_loadImage
{
    //设置导航栏背景图片
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:@"mask_titlebar64"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //设置导航栏标题颜色
    UIColor *color = [manager getThemeColor:@"Mask_Title_color"];
    self.navigationBar.titleTextAttributes = @{
                                               NSForegroundColorAttributeName:color
                                               };
//    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
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

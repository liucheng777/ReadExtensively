//
//  BaseViewController.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "MBProgressHUD.h"
#import "Common.h"
#import "AFHTTPRequestOperation.h"
#import "UIProgressView+AFNetworking.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    MBProgressHUD *_hub;
    UIView *_tipView;
    UIWindow *_tipWindow;
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

    ThemeManager *manager = [ThemeManager shareInstance];
    //01 设置背景图片
    UIImage *bgImage = [manager getThemeImage:@"bg_home.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

-(void)setNavItem
{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(setAction)];
    ThemeManager *manager = [ThemeManager shareInstance];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 0, 100, 43);
    UIImage *bgImage1 = [manager getThemeImage:@"button_title.png"];
    UIImage *image1 = [manager getThemeImage:@"group_btn_all_on_title.png"];
    
    [button1 setBackgroundImage:bgImage1 forState:UIControlStateNormal];
    [button1 setImage:image1 forState:UIControlStateNormal];
    [button1 setTitle:@"设置" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 0, 44, 44);
    
    UIImage *bgImage2 = [manager getThemeImage:@"button_m.png"];
    UIImage *image2 = [manager getThemeImage:@"button_icon_plus.png"];
    [button2 setBackgroundImage:bgImage2 forState:UIControlStateNormal];
    
    [button2 setImage:image2 forState:UIControlStateNormal];
    
    [button2 addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void)setAction
{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

-(void)editAction
{
    MMDrawerController *mmDraw = self.mm_drawerController;
    [mmDraw openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 进度  提示
-(void)showHub:(NSString *)title
{
    _hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_hub show:YES];
    _hub.labelText = title;
    _hub.dimBackground = YES;//阴影
}
-(void)hideHub
{
    [_hub hide:YES];
}
-(void)complete:(NSString *)title
{
    _hub.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    _hub.mode = MBProgressHUDModeCustomView;
    _hub.labelText = title;
    [_hub hide:YES afterDelay:1.5];
}

-(void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operotion
{
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        UILabel *lable = [[UILabel alloc] initWithFrame:_tipWindow.bounds];
        lable.textColor = [UIColor whiteColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = title;
        lable.tag = 84;
        [_tipWindow addSubview:lable];
        
        //进度条
        UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(0, 20 - 3, kScreenWidth, 5);
        progressView.tag = 33;
        progressView.progress = 0.0;
        [_tipWindow addSubview:progressView];
        
    }
    UILabel *lable = (UILabel *)[_tipWindow viewWithTag:84];
    lable.text = title;
    
    UIProgressView *progressView = (UIProgressView *)[_tipWindow viewWithTag:33];
    
    if (show) {
        [_tipWindow setHidden:NO];
        if (operotion != nil) {
            progressView.hidden = NO;
            [progressView setProgressWithUploadProgressOfOperation:operotion animated:YES];
        }
        else
        {
            progressView.hidden = YES;
        }
    }
    else
    {
        [self performSelector:@selector(hideTipWindow) withObject:nil afterDelay:.5];
    }
}

-(void)hideTipWindow
{
    [_tipWindow setHidden:YES];
    _tipWindow = nil;
}

@end

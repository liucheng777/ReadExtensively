//
//  AppDelegate.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "Common.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "LeftViewController.h"
#import "RightViewController.h"
//#import "ThemeButton.h"
#import "ThemeManager.h"

//#import "SendMessageViewController.h"
@interface AppDelegate ()<SinaWeiboDelegate>

@end

@implementation AppDelegate
{
//    NSArray *_switchArray;
//    NSArray *_browse;
//    NSArray *_buttonName;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    _switchArray = @[@"无",@"偏移",@"偏移&缩放",@"旋转",@"视差"];
//    _browse = @[@"小图",@"大图"];
//    _buttonName = @[@"newbar_icon_1",@"newbar_icon_2",@"newbar_icon_3",@"newbar_icon_4",@"newbar_icon_5"];
    
    UIViewController *leftSideDrawerViewController = [[LeftViewController alloc]init];
//    leftSideDrawerViewController.view.backgroundColor = [UIColor redColor];
    MainTabBarController *mainTabVc = [[MainTabBarController alloc] init];
    UIViewController *rightSideDrawerController = [[RightViewController alloc] init];
//    rightSideDrawerController.view.backgroundColor = [UIColor greenColor];
    
    MMDrawerController *drawerViewController = [[MMDrawerController alloc]initWithCenterViewController:mainTabVc leftDrawerViewController:leftSideDrawerViewController rightDrawerViewController:rightSideDrawerController];
    [drawerViewController setMaximumRightDrawerWidth:60.0];
    [drawerViewController setMaximumLeftDrawerWidth:180.0];
    
    [drawerViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState slideAndScaleVisualStateBlock];
    [drawerViewController setDrawerVisualStateBlock:block];
//    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 160, kScreenHeight) style:UITableViewStylePlain];
//    table.delegate = self;
//    table.dataSource = self;
//    ThemeManager *manager = [ThemeManager shareInstance];
//    table.backgroundColor = [UIColor colorWithPatternImage:[manager getThemeImage:@"bg_home.jpg"]];


//    [leftSideDrawerViewController.view addSubview:table];
//    for (int i = 0; i < 5; i++) {
//        ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(10, 64 + i * (40 + 5), 40, 40)];
//        [button setNormalImageName:_buttonName[i]];
//        button.tag = 300 + i;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [rightSideDrawerController.view addSubview:button];
//    }
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    MainTabBarController *mainTabVC = [[MainTabBarController alloc]init];
    self.window.rootViewController = drawerViewController;
    self.sinaWeibo = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"XS27SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    return YES;
}

//-(void)buttonAction:(UIButton *)btn
//{
//    if (btn.tag == 301) {
//        SendMessageViewController *VC = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController" bundle:[NSBundle mainBundle]];
//        
//    }
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return _switchArray.count;
//    }
//    else
//    {
//        return _browse.count;
//    }
//
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *dentifier = @"cell";
//    //2.到重用池中查找单元格
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
//    //3.判断单元格是否为空
//    if (cell == nil) {
//        //创建单元格对象
//        //创建单元格风格
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifier];
//        
//    }
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 150, 20)];
//    [cell.contentView addSubview:lable];
//    if (indexPath.section == 0) {
//
//        lable.text = _switchArray[indexPath.row];
//    }
//    else
//    {
//        lable.text = _browse[indexPath.row];
//    }
//    ThemeManager *manager = [ThemeManager shareInstance];
//    cell.backgroundColor = [UIColor colorWithPatternImage:[manager getThemeImage:@"bg_home.jpg"]];
//    return cell;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 150, 30)];
//        lable.text = @"切换模式";
//        lable.font = [UIFont systemFontOfSize:25 weight:3];
//        return lable;
//    }
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 150, 30)];
//    lable.text = @"浏览模式";
//    lable.font = [UIFont systemFontOfSize:25 weight:3];
//    return lable;
//    
//}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"XS27SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = self.sinaWeibo;
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"XS27SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
  
    [self storeAuthData];

}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];

}



@end

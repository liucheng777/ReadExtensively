//
//  MoreViewController.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCell.h"
#import "ThemeTableViewController.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoreViewController
{
    NSMutableArray *_themeNames;
    UITableView *_table;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _themeNames = [NSMutableArray array];
    _table = [[UITableView alloc]init];

    _table.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    _table = tableView;
    if (section == 0) {
        return 2;
    }
    
    else
    {
        return 1;
    }
        
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ThemeManager *manager = [ThemeManager shareInstance];

    if (indexPath.section == 0) {
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
        if (indexPath.row == 0) {
            ThemeImageView *image = [[ThemeImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
            image.imageName = @"more_icon_theme";
            [cell.contentView  addSubview:image];
            
            cell.contentLable.text = @"主题选择";
            ThemeManager *manager = [ThemeManager shareInstance];
            cell.themeLable.text = [manager.themeName copy];
        }
        else
        {
            ThemeImageView *image = [[ThemeImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
            
            image.imageName = @"more_icon_account";
            [cell.contentView  addSubview:image];
            cell.contentLable.text = @"账户管理";
            cell.themeLable.text = nil;
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
        ThemeImageView *image = [[ThemeImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        image.imageName = @"more_icon_feedback";
        [cell.contentView  addSubview:image];
        cell.contentLable.text = @"意见反馈";
        cell.themeLable.text = nil;
        return cell;
        
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreSecond"];
        UILabel *lable = (UILabel *)[cell.contentView viewWithTag:80];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
        if ([sinaWeibo isLoggedIn]) {
            
            lable.text = @"退出当前账号";
        }
        else
        {
            lable.text = @"登入账号";
        }
        return cell;
    }
}

// 单元格的选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeTableViewController *viewController = [[ThemeTableViewController alloc]init];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (indexPath.section == 2 && indexPath.row == 0)
    {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
        if ([sinaWeibo isLoggedIn]) {
            [sinaWeibo logOut];
            
        }
        else
        {
            [sinaWeibo logIn];
        }
    }
    
    [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)viewDidAppear:(BOOL)animated
{
    [_table reloadData];
}


@end

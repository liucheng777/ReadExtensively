//
//  LeftViewController.m
//  weibo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LeftViewController.h"
#import "ThemeManager.h"
#import "Common.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftViewController
{
    NSArray *_switchArray;
    NSArray *_browse;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _switchArray = @[@"无",@"偏移",@"偏移&缩放",@"旋转",@"视差"];
    _browse = @[@"小图",@"大图"];
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, 160, kScreenHeight) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    ThemeManager *manager = [ThemeManager shareInstance];
    table.backgroundColor = [UIColor colorWithPatternImage:[manager getThemeImage:@"bg_home.jpg"]];
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _switchArray.count;
    }
    else
    {
        return _browse.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *dentifier = @"cell";
    //2.到重用池中查找单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier];
    //3.判断单元格是否为空
    if (cell == nil) {
        //创建单元格对象
        //创建单元格风格
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifier];
        
    }
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 150, 20)];
    [cell.contentView addSubview:lable];
    if (indexPath.section == 0) {
        
        lable.text = _switchArray[indexPath.row];
    }
    else
    {
        lable.text = _browse[indexPath.row];
    }
    ThemeManager *manager = [ThemeManager shareInstance];
    cell.backgroundColor = [UIColor colorWithPatternImage:[manager getThemeImage:@"bg_home.jpg"]];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 150, 30)];
        lable.text = @"切换模式";
        lable.font = [UIFont systemFontOfSize:25 weight:3];
        return lable;
    }
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 150, 30)];
    lable.text = @"浏览模式";
    lable.font = [UIFont systemFontOfSize:25 weight:3];
    return lable;
    
}
@end

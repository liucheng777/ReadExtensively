//
//  ProfileViewController.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileViewController.h"
#import "WXLabel.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "Common.h"
#import "UserCell.h"
#import "WeiboDetailViewController.h"


@interface ProfileViewController ()<SinaWeiboRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProfileViewController
{
    NSMutableArray *_statuesArray;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavItem];
    [self _loadData];
    [self _createTableView];
    
    
}

-(void)_createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 240, kScreenWidth, kScreenHeight - 240) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UINib *nib = [UINib nibWithNibName:@"UserCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"UserCell"];
    [self.view addSubview:_tableView];
}
-(void)_loadData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //    NSLog(@"%@",result);
    NSArray *array = [result objectForKey:@"statuses"];
    _statuesArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in array) {
        WeiboModel *model = [[WeiboModel alloc]initWithDataDic:dic];
      
        [_statuesArray addObject:model];
    }
    WeiboModel *model = _statuesArray[0];
    NSString *urlStr = model.userModel.profile_image_url;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    _userNameLable.text = model.userModel.screen_name;
    _userInfoLable.text = model.userModel.location;

    _attentionLable.numberOfLines = 2;
    _attentionLable.text = [NSString stringWithFormat:@"%@     关注",model.userModel.friends_count];
    _fansLable.numberOfLines = 2;
    _fansLable.text = [NSString stringWithFormat:@"%@       粉丝",model.userModel.followers_count];
    [_tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _statuesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell =(UserCell *)[tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    WeiboModel *model = _statuesArray[indexPath.row];
    
    cell.model = model;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboModel *weiboModel = _statuesArray[indexPath.row];
    
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    vc.model = weiboModel;
    [self.navigationController pushViewController:vc animated:YES];
}



@end

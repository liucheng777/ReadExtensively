//
//  HomeViewController.m
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "ThemeLable.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewFrameLayout.h"
#import "Common.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()<SinaWeiboRequestDelegate>

@end

@implementation HomeViewController
{
    WeiboTableView *_tableView;
    NSMutableArray *_data;
    ThemeImageView *_barImageView;
    ThemeLable *_barLable;
    
}


#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
}
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
//    NSLog(@"%@",result);
    NSArray *statuesArray = [result objectForKey:@"statuses"];
    NSMutableArray *layoutArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in statuesArray) {
        WeiboModel *model = [[WeiboModel alloc]initWithDataDic:dic];
        WeiboViewFrameLayout *layout = [[WeiboViewFrameLayout alloc]init];
        layout.model = model;
        [layoutArray addObject:layout];
    }
    
    if (request.tag == 100) {
        //init
        _data = layoutArray;
//        [self hideHub];
        [self complete:@"加载完成"];
        
    }else if (request.tag == 101)
    {
        //最新
        if (_data == nil) {
            _data = layoutArray;
        }
        else
        {
            [layoutArray addObjectsFromArray:_data];
            _data = layoutArray;
            [self showNewWeiboCount:layoutArray.count];
        }
    }else if (request.tag == 102)
    {
        //更多
        if (_data == nil) {
            _data = layoutArray;
        }
        else
        {
            [_data removeLastObject];
            [_data addObjectsFromArray:layoutArray];
        }
    }
    if (_data.count != 0) {
        _tableView.data = _data;
        [_tableView reloadData];
    }
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
}
-(void)_loadMoreData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    //设置sinceid
    if (_data.count > 0) {
        WeiboViewFrameLayout *layout = [_data lastObject];
        WeiboModel *modal = layout.model;
        [params setObject:modal.weiboIdStr forKey:@"max_id"];
    }
    
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 102;
}

-(void)_loadNewData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    if (_data.count > 0) {
        WeiboViewFrameLayout *layout = _data[0];
        WeiboModel *modal = layout.model;
        [params setObject:modal.weiboIdStr forKey:@"since_id"];
    }
    
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
    request.tag = 101;
    
    
}

-(void)_loadData
{
    
    [self showHub:@"正在加载..."];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = appDelegate.sinaWeibo;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"10" forKey:@"count"];
    
    SinaWeiboRequest *request = [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                       params:params
                   httpMethod:@"GET"
                    delegate:self];
 
    request.tag = 100;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavItem];
    [self _createTableView];
    [self _loadData];
}


-(void)_createTableView
{
    _tableView = [[WeiboTableView alloc]initWithFrame:CGRectMake(0, 64,kScreenWidth , kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showNewWeiboCount:(NSInteger)count
{
    if (_barImageView == nil) {
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth - 10, 40)];
        
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        _barLable = [[ThemeLable alloc] initWithFrame:_barImageView.bounds];
        _barLable.colorName = @"Timeline_Notice_color";
        _barLable.backgroundColor = [UIColor clearColor];
        _barLable.textAlignment = NSTextAlignmentCenter;
        [_barImageView addSubview:_barLable];
        
    }
    if (count > 0) {
        _barLable.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64 + 45);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
            }];
        }];
    }
    //播放声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //注册系统声音
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlayAlertSound(soundId);
}





@end

//
//  LocViewController.m
//  weibo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LocViewController.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"

@interface LocViewController ()

@end

@implementation LocViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"附近商圈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.初始化子视图
    [self _initViews];
    //2.定位
    _locationManager = [[CLLocationManager alloc] init];
    if (kVersion >= 8.0) {
        //请求允许定位
        [_locationManager requestWhenInUseAuthorization];
    }
    //设置请求的准确性
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];
    
}
//初始化子视图
-(void)_initViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}

//开始加载网络
-(void)loadNearByPoisWithLon:(NSString *)lon lat:(NSString *)lat
{
    //01配置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:lon forKey:@"long"];//经度
    [params setObject:lat forKey:@"lat"];//纬度
    [params setObject:@50 forKey:@"count"];//最大请求数量
    //获取附近商家
    __weak __typeof(self) weakSelf = self;
    [DataService requestUrl:nearby_pois httpMethod:@"GET" params:params block:^(id result) {
        NSArray *pois = result[@"pois"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            PoiModel *poi = [[PoiModel alloc] initWithDataDic:dic];
            [dataList addObject:poi];
        }
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.dataList = dataList;
        [strongSelf->_tableView reloadData];
    }];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //停止定位
    [manager stopUpdatingLocation];
    //获取当前请求的位置
    CLLocation *loction = [locations lastObject];

    NSString *lon = [NSString stringWithFormat:@"%f",loction.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",loction.coordinate.latitude];
    //开始加载网络
    [self loadNearByPoisWithLon:lon lat:lat];
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *locCellId = @"locCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:locCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:locCellId];
        
    }
    //获取当前单元格对应的商圈对象
    PoiModel *poi = self.dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.textLabel.text = poi.title;
    return cell;
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

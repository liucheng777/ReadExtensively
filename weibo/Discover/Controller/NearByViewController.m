//
//  NearByViewController.m
//  weibo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiboAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"
#import "WeiboModel.h"
#import "Common.h"
#import "WeiboDetailViewController.h"

@interface NearByViewController ()

@end

@implementation NearByViewController
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _createViews];
    
    CLLocationCoordinate2D coordinate = {30.326943,120.368069};
    WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title = @"汇文教育";
    annotation.subtitle = @"xs27";
    
    [_mapView addAnnotation:annotation];
}

-(void)_createViews
{
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    
    //地图种类
    _mapView.mapType = MKMapTypeStandard;
    
    //用户跟踪模式
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    _mapView.delegate = self;
    
    [self.view addSubview:_mapView];
}

#pragma mark - mapView 代理
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[WeiboAnnotation class]]) {
        return;
    }
    
    WeiboAnnotation *weiboAnnotation =(WeiboAnnotation *)view.annotation;
    
    WeiboModel *weiboModel = weiboAnnotation.model;
    
    WeiboDetailViewController *vc = [[WeiboDetailViewController alloc] init];
    vc.model = weiboModel;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocation *location = userLocation.location;
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"%f,%f",coordinate.longitude,coordinate.latitude);
    
    //设置地图的显示区域
    CLLocationCoordinate2D center = coordinate;
    //数值越小 越精确
    MKCoordinateSpan span= {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    mapView.region = region;
    
    NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    [self _loadNearByData:lon lat:lat];
}

//标注视图获取
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    //处理用户当前位置
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
//        //颜色
//        pin.pinColor = MKPinAnnotationColorPurple;
//        //从天而降
//        pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        
//        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    
//    }
//    return pin;
//}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[WeiboAnnotation class]]) {
        WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        if (view == nil) {
            view = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"view"];
            
        }
        view.annotation = annotation;
        [view setNeedsLayout];
        return view;
    }
    return nil;
}

-(void)_loadNearByData:(NSString *)lon lat:(NSString *)lat
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    [DataService requestUrl:nearby_timeline httpMethod:@"GET" params:params block:^(id result) {
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[NSMutableArray alloc] initWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses) {
            WeiboModel *model = [[WeiboModel alloc] initWithDataDic:dic];
            WeiboAnnotation *annotation = [[WeiboAnnotation alloc] init];
            annotation.model = model;
            [annotationArray addObject:annotation];
        }
        [_mapView addAnnotations:annotationArray];
    }];
}


//

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

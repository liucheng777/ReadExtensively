//
//  RightViewController.m
//  weibo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SendMessageViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "ThemeManager.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavigationController.h"
#import "LocViewController.h"


@interface RightViewController ()
{
    NSArray *_buttonName;
}

@end

@implementation RightViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _buttonName = @[@"newbar_icon_1",@"newbar_icon_2",@"newbar_icon_3",@"newbar_icon_4",@"newbar_icon_5"];
    [self createButton];
}

-(void)createButton
{
    for (int i = 0; i < 5; i++) {
        ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(10, 64 + i * (40 + 5), 40, 40)];
        [button setNormalImageName:_buttonName[i]];
        button.tag = 300 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

-(void)buttonAction:(ThemeButton *)btn
{
    if (btn.tag == 300) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            SendMessageViewController *vc = [[SendMessageViewController alloc] init];
            vc.title = @"发送微博";
            BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
    
    }
    else if (btn.tag == 304)
    {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            LocViewController *vc = [[LocViewController alloc] init];
            vc.title = @"附近商圈";
            //创建导航控制器
            BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:vc];
            [self.mm_drawerController presentViewController:baseNav animated:YES completion:nil];
        }];
    }
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

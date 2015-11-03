//
//  WeiboTableView.h
//  weibo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSArray *data;

@end

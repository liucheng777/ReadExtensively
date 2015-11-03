//
//  WeiboDetailViewController.h
//  weibo
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboModel.h"
#import "CommentTableView.h"
#import "SinaWeibo.h"

@interface WeiboDetailViewController : BaseViewController<SinaWeiboRequestDelegate>
{
    CommentTableView *_tableView;
}
@property(nonatomic,strong) WeiboModel *model;

@property(nonatomic,strong) NSMutableArray *data;
@end

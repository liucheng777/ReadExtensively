//
//  WeiboCell.h
//  weibo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboViewFrameLayout.h"
#import "WeiboView.h"

@interface WeiboCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *rePostLable;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;
@property (weak, nonatomic) IBOutlet UILabel *srcLable;

@property (strong,nonatomic) WeiboView *weiboView;

//@property (nonatomic,strong) WeiboModel *model;

@property (nonatomic,strong) WeiboViewFrameLayout *layout;

@end

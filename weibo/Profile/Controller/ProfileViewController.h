//
//  ProfileViewController.h
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLable;
@property (weak, nonatomic) IBOutlet UILabel *userIntroLable;
@property (weak, nonatomic) IBOutlet UILabel *attentionLable;
@property (weak, nonatomic) IBOutlet UILabel *fansLable;
@property (weak, nonatomic) IBOutlet UILabel *dataLable;
@property (weak, nonatomic) IBOutlet UILabel *moreLable;

@end

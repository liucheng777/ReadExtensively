//
//  BaseViewController.h
//  weibo
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AFHTTPRequestOperation;

@interface BaseViewController : UIViewController

-(void)setNavItem;

-(void)showHub:(NSString *)title;
-(void)hideHub;
-(void)complete:(NSString *)title;

-(void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operotion;

@end

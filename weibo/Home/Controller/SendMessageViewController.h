//
//  SendMessageViewController.h
//  weibo
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ZoomImageView.h"
#import <CoreLocation/CoreLocation.h>
#import "FaceScrollView.h"

@interface SendMessageViewController : BaseViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITabBarDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate,FaceViewDelegate>
{
    //文本编辑
    UITextView *_textView;
    //工具栏
    UIView *_editorBar;
    //显示缩略图
    ZoomImageView *_zoomImageView;
    //位置显示
    CLLocationManager *_locationManager;
    UILabel *_locLable;
    
    //表情面板
    FaceScrollView *_faceViewPanel;

    
}

@end

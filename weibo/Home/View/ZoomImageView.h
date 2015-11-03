//
//  ZoomImageView.h
//  weibo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@class ZoomImageView;
@protocol ZoomImageViewDelegate <NSObject>

//图片将要放大
-(void)imageWillZoomIn:(ZoomImageView *)imageView;
-(void)imageWillZoomOut:(ZoomImageView *)imageView;
@end

@interface ZoomImageView : UIImageView<NSURLConnectionDataDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    UIScrollView *_scrollew;
    UIImageView *_fullImageView;
}
@property (nonatomic,weak)id<ZoomImageViewDelegate> delegate;

@property(nonatomic,copy) NSString *fullImageUrlString;
@property(nonatomic,assign) BOOL isGif;
@property(nonatomic,strong) UIImageView *iconView;

@end

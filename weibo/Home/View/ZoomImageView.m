//
//  ZoomImageView.m
//  weibo
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ZoomImageView.h"
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "Common.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation ZoomImageView
{
    UIScrollView *_scrollView;
    double _length;
    NSURLConnection *_connection;
    NSMutableData *_data;
    MBProgressHUD *_hud;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        [self initTap];
        [self createIconView];
    }
    return self;
}

-(void)initTap
{
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
    [self addGestureRecognizer:tap];
}
//放大
-(void)zoomOut
{
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    _scrollView.backgroundColor = [UIColor clearColor];
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    
    [UIView animateWithDuration:.35 animations:^{
        _fullImageView.frame = frame;
        _fullImageView.top += _scrollView.contentOffset.y;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
    }];
    self.hidden = NO;
    [_connection cancel];
}
-(void)zoomIn
{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }
    
    //创建缩放视图
    [self createViews];
    
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    self.hidden = YES;
    
    _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
    _hud.mode = MBProgressHUDModeAnnularDeterminate;
    _hud.progress = 0.0;
    
    [UIView animateWithDuration:.35 animations:^{
        _fullImageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        [self downloadImage];
    }];
}

-(void)createViews
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:_scrollView];
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        _fullImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [_scrollView addGestureRecognizer:longPress];
    }
}
//gif小图标
-(void)createIconView
{
    _iconView = [[UIImageView alloc] init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif"];
    [self addSubview:_iconView];
    _iconView.hidden = YES;
}

-(void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateEnded) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否保存图片" message:@"存储于相册中" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
//        [_scrollView addSubview:alert];
        [alert show];
        
        
    }
}

#pragma mark- UIAlertViewDelegete
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImage *image = _fullImageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }

}



//图片保存成功调用的协议方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存完毕";
    [hud hide:YES afterDelay:.5];
}


-(void)downloadImage
{
    if (_fullImageUrlString.length != 0) {
        NSURL *url = [NSURL URLWithString:_fullImageUrlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpReponse = (NSHTTPURLResponse *)response;
    NSDictionary *headFields = [httpReponse allHeaderFields];
    
    NSString *lengthStr = [headFields objectForKey:@"Content-Length"];
    _length = [lengthStr doubleValue];
    _data = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    CGFloat progress = _data.length / _length;
    _hud.progress = progress;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_hud hide:YES];
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    //尺寸处理
    CGFloat length = image.size.height / image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        [UIView animateWithDuration:.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
        }];
    }
    
#warning
    if (_isGif) {
        [self showGif];
    }
}

-(void)showGif
{
// //  01webImage播放
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//    webView.userInteractionEnabled = NO;
//    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:webView];
    //02 三方
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
//    //03 用imageIO
//    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
//    size_t count = CGImageSourceGetCount(source);
//    NSMutableArray *images = [NSMutableArray array];
//    NSTimeInterval duration = 0.0f;
//    for (int i = 0; i < count; i++) {
//        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
//        duration += 0.1;
//        [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
//        CGImageRelease(image);
//    }
    
    //播放YI
    //    _fullImageView.animationImages = images;
    //    _fullImageView.animationDuration = duration;
    //    [_fullImageView startAnimating];
    //
    
    //播放二
    
//    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
//    _fullImageView.image = animatedImage;
//    
//    CFRelease(source);
//    CFRelease(source);
}

@end

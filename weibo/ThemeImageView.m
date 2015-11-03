//
//  ThemeImageView.m
//  weibo
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

-(void)themeDidChange:(NSNotification *)notification
{
    [self loadImage];
    
    
}
-(void)setImageName:(NSString *)imageName
{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        [self loadImage];
    }
}
-(void)loadImage
{
    ThemeManager *manager = [ThemeManager shareInstance];
    UIImage *image = [manager getThemeImage:self.imageName];
    image = [image stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    if (image != nil) {
        self.image = image;
    }
}

@end

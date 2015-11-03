//
//  ThemeLable.m
//  weibo
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeLable.h"
#import "ThemeManager.h"

@implementation ThemeLable

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNameDidChanged:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}


-(void)awakeFromNib
{
 
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNameDidChanged:) name:kThemeNameDidChangeNotification object:nil];
    
}



-(void)themeNameDidChanged:(NSNotification *)notifacation
{
    [self _loadColor];
}

-(void)setColorName:(NSString *)colorName
{
    if (![_colorName isEqualToString:colorName]) {
        _colorName = [colorName copy];
        [self _loadColor];
    }
}

-(void)_loadColor
{
    ThemeManager *manager = [ThemeManager shareInstance];
    self.textColor = [manager getThemeColor:self.colorName];
}

@end

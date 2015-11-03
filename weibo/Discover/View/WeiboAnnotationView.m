//
//  WeiboAnnotationView.m
//  weibo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiboAnnotation.h"
#import "UIImageView+WebCache.h"

@implementation WeiboAnnotationView

-(instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _createViews];
        self.frame = CGRectMake(0, 0, 145, 40);
    }
    return self;
}

-(void)_createViews
{
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _headImageView.image = [UIImage imageNamed:@"icon"];
    
    _textLablel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 40)];
    _textLablel.text = @"hello world";
    [self addSubview:_headImageView];
    [self addSubview:_textLablel];
}
-(void)layoutSubviews
{
    WeiboAnnotation *annotation = self.annotation;
    WeiboModel *model = annotation.model;
    _textLablel.text = model.text;
    _textLablel.font = [UIFont systemFontOfSize:10];
    _textLablel.numberOfLines = 3;
    //头像
    NSString *urlStr = model.userModel.profile_image_url;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    
}

@end

//
//  WeiboCell.m
//  weibo
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"

@implementation WeiboCell

- (void)awakeFromNib {
    [self _createSubView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)_createSubView
{
    _weiboView = [[WeiboView alloc]init];
    [self.contentView addSubview:_weiboView];
    
}

-(void)setLayout:(WeiboViewFrameLayout *)layout
{
    if (_layout != layout) {
        _layout = layout;
        _weiboView.layout = _layout;
        [self setNeedsLayout];
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    WeiboModel *model = _layout.model;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:model.userModel.profile_image_url]];
    _userName.text = model.userModel.screen_name;
    
    NSString *commentCount = [model.commentsCount stringValue];
    _commentLable.text = [NSString stringWithFormat:@"评论:%@",commentCount];
    NSString *repostCount = [model.repostsCount stringValue];
    _rePostLable.text = [NSString stringWithFormat:@"转发:%@",repostCount];
    _srcLable.text = model.source;
    _weiboView.frame = _layout.frame;
}

@end

//
//  UserCell.m
//  weibo
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UserCell.h"
#import "UIImageView+WebCache.h"

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)setModel:(WeiboModel *)model
{
    if (_model != model) {
        _model = model;
        [self setNeedsDisplay];
    }
}

-(void)layoutSubviews
{
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:_model.userModel.profile_image_url]];
    _userNameLable.text = _model.userModel.screen_name;
    _conntentLable.text = _model.text;
    NSString *dateStr = _model.createDate;
    NSArray *date = [dateStr componentsSeparatedByString:@"+"];
    _dateLable.text = date[0];
    _sourceLable.text = _model.source;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

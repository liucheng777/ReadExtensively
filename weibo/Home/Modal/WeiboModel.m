//
//  WeiboModel.m
//  XSWeibo
//
//  Created by gj on 15/9/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"


@implementation WeiboModel


- (NSDictionary*)attributeMapDictionary{
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                    
                             };
    
    return mapAtt;
}


- (void)setAttributes:(NSDictionary *)dataDic{
    //调用父类的设置方法
   [super setAttributes:dataDic];

    //用户信息解析
    NSDictionary *userDic  = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        _userModel = [[UserModel alloc] initWithDataDic:userDic];
    }
    if (_source != nil) {
        
        NSString *regex =  @">.+<";
        
        NSArray *array = [_source componentsMatchedByRegex:regex];
        if (array.count != 0) {
            NSString *temp = array[0];
            temp =  [temp substringWithRange:NSMakeRange(1, temp.length-2)];
            
            _source = [NSString stringWithFormat:@"来源:%@",temp];
            
        }
    }
    
    //被转发的微博
    NSDictionary *reWeiBoDic = [dataDic objectForKey:@"retweeted_status"];
    if (reWeiBoDic != nil) {
        _reWeiboModel = [[WeiboModel alloc] initWithDataDic:reWeiBoDic];
    }

    
    NSString *regex = @"\\[\\w*\\]";
    NSArray *faceItems = [_text componentsSeparatedByRegex:regex];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    
}



@end

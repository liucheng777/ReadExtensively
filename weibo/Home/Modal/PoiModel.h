//
//  PoiModel.h
//  weibo
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseModel.h"

@interface PoiModel : BaseModel

@property (nonatomic ,copy) NSString *poiid;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *lon;
@property (nonatomic ,copy) NSString *lat;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *icon;


@end

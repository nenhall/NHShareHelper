//
//  NHShareModel.h
//  NHShareHelper
//
//  Created by neghao on 2017/3/21.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHItemModel : NSObject
@property (nonatomic, copy) NSString * action;//timeline favorite authentication share
@property (nonatomic, copy) NSString * image;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * shareType;
@property (nonatomic, copy) NSString * shareDetail;
@property (nonatomic, copy) NSString * shareImage;
@property (nonatomic, copy) NSString * shareTitle;
@property (nonatomic, copy) NSString * zone;
@property (nonatomic, copy) NSString * type;

@end


@interface NHSection : NSObject
@property (nonatomic, strong) NSMutableSet<NHItemModel *> *share;
@property (nonatomic, copy) NSMutableSet<NHItemModel *> *authentication;
@end

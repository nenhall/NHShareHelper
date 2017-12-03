//
//  NHShareModel.h
//  NHShareHelper
//
//  Created by neghao on 2017/3/21.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHItemModel : NSObject
@property (nonatomic, assign) NSInteger shareType;
@property (nonatomic, copy) NSString * shareAction;
@property (nonatomic, copy) NSString * shareImage;
@property (nonatomic, copy) NSString * shareTitle;

@end



@interface NHShareModel : NSObject
@property (nonatomic, strong) NHItemModel *model;
- (NHShareModel *(^)(NSInteger shareType))shareType;
- (NHShareModel *(^)(NSString *shareTitle))shareTitle;
- (NHShareModel *(^)(NSString *shareImage))shareImage;
- (NHShareModel *(^)(NSString *shareAction))shareAction;
@end


@interface NSMutableArray (cellinfo)
/**
 添加一个个人中心的cell model
 */
- (instancetype)addCellInfo:(void(^)(NHShareModel *cellinfo))cellinfo;

@end

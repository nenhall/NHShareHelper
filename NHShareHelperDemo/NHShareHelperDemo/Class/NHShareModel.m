//
//  NHShareModel.m
//  NHShareHelper
//
//  Created by neghao on 2017/3/21.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHShareModel.h"

@implementation NHShareModel

- (NHShareModel *(^)(NSInteger))shareType {
    return ^(NSInteger shareType){
        _model.shareType = shareType;
        return self;
    };
}

- (NHShareModel *(^)(NSString *))shareImage {
    return ^(NSString *shareImage){
        _model.shareImage = shareImage;
        return self;
    };
}

- (NHShareModel *(^)(NSString *))shareTitle {
    return ^(NSString *shareTitle){
        _model.shareTitle = shareTitle;
        return self;
    };
}

- (NHShareModel *(^)(NSString *))shareAction {
    return ^(NSString *shareAction){
        _model.shareAction = shareAction;
        return self;
    };
}

@end

@implementation NHItemModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end


@implementation NSMutableArray (cellinfo)

- (instancetype)addCellInfo:(void (^)(NHShareModel *))cellinfo {
    
    NHShareModel *cellModel = [[NHShareModel alloc] init];
    
    cellModel.model = [[NHItemModel alloc] init];
    
    [self addObject:cellModel.model];
    
    cellinfo(cellModel);
    
    return self;
}

@end

//
//  NHUserinfo.m
//  NHShareHelper
//
//  Created by neghao on 2017/2/20.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHUserinfo.h"

@implementation NHUserinfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

}
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
@end

@implementation NHWechatUserinfo
@end

@implementation NHQQUserinfo
@end

@implementation NHWeiBoUserinfo
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"class"]) {
        _wb_class = value;
    }
    
    if ([key isEqualToString:@"id"]) {
        _wb_id = value;
    }
}
@end

@implementation Insecurity
@end

@implementation Pic_urls
@end

@implementation Hot_weibo_tags
@end

@implementation Text_tag_tips
@end

@implementation Annotations
@end

@implementation Visible
@end

@implementation Darwin_tags :NSObject
@end

@implementation Status :NSObject
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        _status_id = value;
    }
}
@end

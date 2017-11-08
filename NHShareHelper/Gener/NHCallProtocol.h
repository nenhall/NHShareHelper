//
//  NHCallProtocol.h
//  NHShareHelperDemo
//
//  Created by neghao on 3/26/17.
//  Copyright © 2017 NegHao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, NHAppType) {
    NHApp_Wechat,
    NHApp_WeiBo,
    NHApp_QQ,
    NHApp_Alibaba,
    NHApp_Google,
    NHApp_Facebook,
    NHApp_Twitter,
};

@class NHUserinfo;
@protocol NHCallProtocol <NSObject>
- (void)callType:(NHAppType)appType userinfo:(__kindof NHUserinfo *)userinfo errorMsg:(NSString *)errorMsg;
- (void)callType:(NHAppType)appType loginSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
- (void)callType:(NHAppType)appType shareSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;

@end

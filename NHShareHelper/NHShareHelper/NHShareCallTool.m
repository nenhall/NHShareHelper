//
//  NHShareCallTool.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHShareCallTool.h"
#import "NHShareConfiguration.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>



#define FacebookID      @"243737089423586"

@interface NHShareCallTool ()<NHQQCallDelegate,NHWechatCallDelegate,NHWeiBoCallDelegate>
@property (nonatomic, strong)NHQQCall *QQCall;
@property (nonatomic, strong)NHWechatCall *wechatCall;
@property (nonatomic, strong)NHWeiBoCall  *weiBoCall;
@end

@implementation NHShareCallTool
NSSingletonM(NHShareCallTool);

/** 第三方注册*/
+ (instancetype)registerApps{
    return [[NHShareCallTool sharedNHShareCallTool] registerApps];
}

- (instancetype)registerApps{
    [self.QQCall tencentQQRegistWithAppID:QQAppID];
    [self.weiBoCall weiboRegistWithAppID:WBAppID];
    [self.wechatCall wechatRegistWithAppID:WXAppID];
    return _instance;
}

- (void)appRegistRequestWithType:(NHAppType)type AppID:(NSString *)appid {
    if (type == NHApp_QQ) {
        [self.QQCall tencentQQRegistWithAppID:appid];
        
    }else if (type == NHApp_WeiBo){
        [self.weiBoCall weiboRegistWithAppID:appid];
        
    }else if (type == NHApp_Wechat){
        [self.wechatCall wechatRegistWithAppID:appid];
    }
}

- (void)appLoginRequestWithType:(NHAppType)type {
    if (type == NHApp_QQ) {
        [self.QQCall tencentQQLoginRequest];
    }else if (type == NHApp_WeiBo){
        [self.weiBoCall weiboLoginRequest];

    }else if (type == NHApp_Wechat){
        [self.wechatCall wechatLoginRequestSetViewController:nil];
    }
}


- (instancetype)addDelegateObserver:(id)delegate{
    self.delegate = delegate;
    return self;
}

/** QQ分享*/


/**
 *  QQ注册
 */
+ (instancetype)registQQWithAppID:(NSString *)appid {
    [[NHShareCallTool sharedNHShareCallTool].QQCall tencentQQRegistWithAppID:appid];
    return _instance;
}

/**
 *  微博注册
 */
+ (instancetype)registWeiBoWithAppID:(NSString *)appid {
    [[NHShareCallTool sharedNHShareCallTool].weiBoCall weiboRegistWithAppID:appid];
    return _instance;
}

/**
 *  微信注册
 */
+ (instancetype)registWechatWithAppID:(NSString *)appid {
    [[NHShareCallTool sharedNHShareCallTool].wechatCall wechatRegistWithAppID:appid];
    return _instance;
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [_instance application:application
                          openURL:url
                sourceApplication:sourceApplication
                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)application
            openURL:(nonnull NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation {
    NHNSLog(@"%@---%@",url.scheme,url.description);

    if ([url.scheme isEqualToString:AppendString(@"tencent", QQAppID)]) {
        return [self.QQCall handleOpenURL:url];
        
    }else if ([url.scheme isEqualToString:AppendString(@"",WXAppID)]) {
        return [self.wechatCall handleOpenURL:url];
        
    }else if ([url.scheme isEqualToString:AppendString(@"wb", WBAppID)]) {
        return [self.weiBoCall handleOpenURL:url];
        
    }else if ([url.scheme isEqualToString:AppendString(@"fb", FacebookID)]) {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
    return YES;
}


#pragma mark - QQ \ wechat \ weibo消息回调
- (void)loginResultAppType:(NHAppType)appType Success:(BOOL)success errorMsg:(NSString *)errorMsg {
    if (success) {
        //登录成功
        
    }else{
        //登录失败
        NHTipWithMessage(errorMsg);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_loginResultAppType:Success:errorMsg:)]) {
        [self.delegate nh_loginResultAppType:appType Success:success errorMsg:errorMsg];
    }
}


#pragma mark - NHWechatCallDelegate
- (void)wechatLoginResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
   [self loginResultAppType:NHApp_Wechat Success:success errorMsg:errorMsg];
}

- (void)wechatRequestUserinfo:(NHWechatUserinfo *)userinfo error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_wechatRequestUserinfo:error:)]) {
        [self.delegate nh_wechatRequestUserinfo:userinfo error:error];
    }
}

- (void)wechatShareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
//    NSDictionary *userinfo = @{@"success":@(success),@"errorMsg":errorMsg ?: @"null"};
//    [[NSNotificationCenter defaultCenter] postNotificationName:ShareResultNotification object:nil userInfo:userinfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_shareResultSuccess:errorMsg:shareType:)]) {
        [self.delegate nh_shareResultSuccess:success errorMsg:errorMsg shareType:NHApp_Wechat];
    }
}


#pragma mark - NHQQCallDelegate
- (void)QQLoginResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
    [self loginResultAppType:NHApp_QQ Success:success errorMsg:errorMsg];
}

- (void)QQRequestUserinfo:(NHQQUserinfo *)userinfo errorMsg:(NSString *)errorMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_QQRequestUserinfo:error:)]) {
        [self.delegate nh_QQRequestUserinfo:userinfo error:ERROR_STATUS(-1, ERROR_MSG(errorMsg, errorMsg, errorMsg))];
    }
}

- (void)QQShareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_shareResultSuccess:errorMsg:shareType:)]) {
        [self.delegate nh_shareResultSuccess:success errorMsg:errorMsg shareType:NHApp_QQ];
    }
}



#pragma mark - NHWechatCallDelegate
- (void)weiBoLoginResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
    [self loginResultAppType:NHApp_WeiBo Success:success errorMsg:errorMsg];
}
- (void)weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_weiBoRequestUserinfo:error:)]) {
        [self.delegate nh_weiBoRequestUserinfo:userinfo error:error];
    }
}

- (void)weiBoShareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_shareResultSuccess:errorMsg:shareType:)]) {
        [self.delegate nh_shareResultSuccess:success errorMsg:errorMsg shareType:NHApp_QQ];
    }
}


#pragma mark - init
#pragma mark -
- (NHQQCall *)QQCall{
    if (!_QQCall) {
        _QQCall = [[NHQQCall alloc] init];
        _QQCall.delegate = self;
    }
    return _QQCall;
}

- (NHWechatCall *)wechatCall{
    if (!_wechatCall) {
        _wechatCall = [[NHWechatCall alloc] init];
        _wechatCall.delegate = self;
    }
    return _wechatCall;
}

- (NHWeiBoCall *)weiBoCall{
    if (!_weiBoCall) {
        _weiBoCall = [[NHWeiBoCall alloc] init];
        _weiBoCall.delegate = self;
    }
    return _weiBoCall;
}

@end

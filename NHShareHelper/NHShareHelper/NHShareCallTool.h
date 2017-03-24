//
//  NHShareCallTool.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHSingleton.h"
#import "NHQQCall.h"
#import "NHWeiBoCall.h"
#import "NHWechatCall.h"
#import "NHFacebook.h"


typedef NS_ENUM (NSInteger, NHAppType) {
    NHApp_Wechat,
    NHApp_WeiBo,
    NHApp_QQ,
    NHApp_Alibaba,
    NHApp_Google,
    NHApp_Facebook,
    NHApp_Twitter,
};
@protocol NHShareCallToolDelegate <NSObject>
/**
 *  获取QQ用户信息结果
 */
- (void)nh_QQRequestUserinfo:(NHQQUserinfo *)userinfo error:(NSError *)error;

/**
 *  获取微信用户信息结果
 */
- (void)nh_wechatRequestUserinfo:(NHWechatUserinfo *)userinfo error:(NSError *)error;

/**
 *  获取微博用户信息结果
 */
- (void)nh_weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo error:(NSError *)error;

/**
 *  登陆结果，调用此方法时还未请求到用户信息
    根据项目需要，如果你需要在登录后立即做些什么，请实现此代理方法
 *
 *  @param appType  登录类型
 *  @param success  是否成功
 *  @param errorMsg 错误信息
 */
- (void)nh_loginResultAppType:(NHAppType)appType Success:(BOOL)success errorMsg:(NSString *)errorMsg;

/**
 *  分享结果
 *
 *  @param success   是否成功
 *  @param errorMsg  错误信息
 *  @param shareType 分享类型
 */
- (void)nh_shareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg shareType:(NHAppType)shareType;
@end

@interface NHShareCallTool : NSObject
@property (nonatomic, assign) id<NHShareCallToolDelegate> delegate;
@property (nonatomic, strong, readonly)NHQQCall *QQCall;
@property (nonatomic, strong, readonly)NHWechatCall *wechatCall;
@property (nonatomic, strong, readonly)NHWeiBoCall  *weiBoCall;

NSSingletonH(NHShareCallTool);

/**
 *  此方法一起注册所有第三方分享sdk
 *  但需要将宏定义的第三方app信息改成你自己的
 */
+ (instancetype)registerApps;

+ (instancetype)registWechatWithAppID:(NSString *)appid;
+ (instancetype)registQQWithAppID:(NSString *)appid;
+ (instancetype)registWeiBoWithAppID:(NSString *)appid;


+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/*
 添加代理方
 **/
- (instancetype)addDelegateObserver:(id)delegate;

/**
 *  登录请求
 *  @param type 登录类型
 */
- (void)appLoginRequestWithType:(NHAppType)type;

/**
 *  注册请求
 *  @param type 注册类型
 */
- (void)appRegistRequestWithType:(NHAppType)type AppID:(NSString *)appid;

@end

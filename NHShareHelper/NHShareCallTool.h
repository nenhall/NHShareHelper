//
//  NHShareCallTool.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHSingleton.h"
#import "NHShareConfiguration.h"
#import "NHCall.h"
#import "NHQQCall.h"
#import "NHWeiBoCall.h"
#import "NHWechatCall.h"
#import "NHFacebookCall.h"
#import "NHShareCallToolProtocol.h"



UIKIT_EXTERN NSString * const NHWechat;
UIKIT_EXTERN NSString * const NHWeiBo;
UIKIT_EXTERN NSString * const NHQQ;
UIKIT_EXTERN NSString * const NHAlibaba;
UIKIT_EXTERN NSString * const NHFacebook;
UIKIT_EXTERN NSString * const NHGoogle;
UIKIT_EXTERN NSString * const NHTwitter;



@protocol NHShareCallToolDelegate <NSObject,NHShareCallToolProtocol>
/**
 *  获取QQ用户信息结果
 */
- (void)nh_QQRequestUserinfo:(NHQQUserinfo *)userinfo errorMsg:(NSString *)error;

/**
 *  获取微信用户信息结果
 */
- (void)nh_wechatRequestUserinfo:(NHWechatUserinfo *)userinfo errorMsg:(NSString *)error;

/**
 *  获取微博用户信息结果
 */
- (void)nh_weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo errorMsg:(NSString *)error;

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
NSSingletonH(CallTool);

/**
 *  注册第三方app
 *  @param appConstStrs 本类定义的常量值 eg. NHWechat
 */
+ (instancetype)registerAppSetAppConsts:(NSArray *)appConstStrs;

/**
 *  app内跳转回调
 */
+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

/*
 设置代理
 **/
- (instancetype)addDelegateObserver:(id)delegate;

/**
 *  登录请求
 *
 *  @param appConstString appConstStrs eg. NHWechat
 *  @param viewController 微信web页面登录才用到
 */
+ (void)loginSetAppConst:(NSString *)appConstString viewController:(UIViewController *)viewController;

@end

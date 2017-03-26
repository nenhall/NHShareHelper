//
//  NHCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 17/3/25.
//  Copyright © 2017年 NegHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NHUserinfo.h"
#import "NHSingleton.h"



typedef NS_ENUM (NSInteger, NHAppType) {
    NHApp_Wechat,
    NHApp_WeiBo,
    NHApp_QQ,
    NHApp_Alibaba,
    NHApp_Google,
    NHApp_Facebook,
    NHApp_Twitter,
};

@protocol NHCallDelegate <NSObject>
- (void)callType:(NHAppType)appType userinfo:(__kindof NHUserinfo *)userinfo errorMsg:(NSString *)errorMsg;
- (void)callType:(NHAppType)appType loginSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
- (void)callType:(NHAppType)appType shareSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;

@end

@interface NHCall : NSObject
{
    NSNumber *_isOpenURL;
    __unsafe_unretained id<NHCallDelegate> _callDelegate;
}
@property (nonatomic, assign) id<NHCallDelegate> callDelegate;
@property (nonatomic, strong) NSNumber *isOpenURL;
//NSSingletonH(call)


// app注册请求
- (BOOL)callRegistApp;

/**
 *  微信app登录事件请求
 *  @param viewController 微信web页面登录才用到
 */
- (void)callLoginRequestSetViewController:(UIViewController *)viewController;

/**
 *  回调url
 */
- (BOOL)callApplication:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation;

@end

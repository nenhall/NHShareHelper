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
#import "NHShareConfiguration.h"
#import "NHCallProtocol.h"



@interface NHCall : NSObject
{
    NSNumber *_isOpenURL;
}
@property (nonatomic, strong) NSNumber *isOpenURL;

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

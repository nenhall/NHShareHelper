//
//  AppDelegate.m
//  NHShareHelperDemo
//
//  Created by neghao on 17/3/25.
//  Copyright © 2017年 NegHao. All rights reserved.
//

#import "AppDelegate.h"
#import "NHShareCallTool.h"
#import "NHFacebookCall.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //注册app
    [NHShareCallTool registerAppSetAppConsts:@[NHQQ,NHWeiBo,NHWechat,NHFacebook]];
    
    
    //需要使用到facebook才需要调用
    [NHFacebookCall application:application
didFinishLaunchingWithOptions:launchOptions
enableUpdatesOnAccessTokenChange:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [NHShareCallTool application:application
                                openURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [NHShareCallTool application:application
                                openURL:url
                      sourceApplication:nil
                             annotation:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [NHShareCallTool application:application
                                        openURL:url
                              sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                     annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return handled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //需要使用到facebook记录功能才需要调用
    [NHFacebookCall activateApp];
}

@end

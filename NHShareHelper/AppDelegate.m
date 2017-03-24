//
//  AppDelegate.m
//  NHShareHelper
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "NHShareCallTool.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //一键注册所有的app
    [NHShareCallTool registerApps];
    
    //需要使用到facebook才需要调用
    [NHFacebook application:application
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
    [NHFacebook activateApp];
}

@end

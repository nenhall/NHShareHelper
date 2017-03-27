//
//  NHCall.m
//  NHShareHelperDemo
//
//  Created by neghao on 17/3/25.
//  Copyright © 2017年 NegHao. All rights reserved.
//

#import "NHCall.h"


@interface NHCall ()

@end

@implementation NHCall
@synthesize isOpenURL = _isOpenURL;

- (BOOL)callRegistApp {
    return NO;
}



- (void)callLoginRequestSetViewController:(UIViewController *)viewController {

}

- (BOOL)callApplication:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation {
    return [_isOpenURL boolValue];
}

@end

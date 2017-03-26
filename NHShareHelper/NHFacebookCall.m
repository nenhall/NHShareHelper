//
//  NHFacebookCall.m
//  NHShareHelper
//
//  Created by neghao on 2017/3/23.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHFacebookCall.h"

@implementation NHFacebookCall
- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(_accessTokenChanged:)
//                                                     name:FBSDKAccessTokenDidChangeNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(_currentProfileChanged:)
//                                                     name:FBSDKProfileDidChangeNotification
//                                                   object:nil];
    }
    return self;
}

- (BOOL)callApplication:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation {
   return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
}


+ (BOOL)application:(UIApplication *)application
       didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    enableUpdatesOnAccessTokenChange:(BOOL)enable {
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}


+ (FBSDKProfile *)currentProfile{
    return [FBSDKProfile currentProfile];
}

+ (FBSDKAccessToken *)currentAccessToken{
    return [FBSDKAccessToken currentAccessToken];
}

- (BOOL)isEqualToAccessToken:(FBSDKAccessToken *)token{
   return [token isEqualToAccessToken:[FBSDKAccessToken currentAccessToken]];
}

+ (void)setCurrentAccessToken:(FBSDKAccessToken *)token{
    [FBSDKAccessToken setCurrentAccessToken:token];
}

+ (void)activateApp{
    [FBSDKAppEvents activateApp];
}


+ (void)createLoginManagerReadPermissions:(NSArray *)permissions
                            loginBehavior:(FBSDKLoginBehavior)loginBehavior
                       fromViewController:(UIViewController *)fromViewController
                                  handler:(NHFaceLoginManagerRequestTokenHandler)handler {
    if ([NHFacebookCall currentAccessToken]) {
        if (handler) {
            handler(nil,[NHFacebookCall currentProfile],nil);
        }
        
    }else{
        FBSDKLoginManager *manager = [[FBSDKLoginManager alloc] init];
        manager.loginBehavior = FBSDKLoginBehaviorWeb;
        [manager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                       fromViewController:fromViewController
                                  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                      NSLog(@"%@---%@",result,error);
                                         FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
                                         [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                             NSLog(@"%@--%@",connection,result);
                                             if (handler) {
                                                 handler(result,[NHFacebookCall currentProfile],error);
                                             }
                                         }];
                                  }];
    }
}

// Observe a new token, so save it to our SUCache and update
// the cell.
- (void)_accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    
    if (!token) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [FBSDKProfile setCurrentProfile:nil];
        
    } else {
        NSLog(@"%@",token.userID);
    }
}

// The profile information has changed, update the cell and cache.
- (void)_currentProfileChanged:(NSNotification *)notification
{
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    if (profile) {

        NSLog(@"profile:%@",profile.name);
    }
}

@end

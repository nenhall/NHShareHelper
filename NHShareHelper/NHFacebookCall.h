//
//  NHFacebookCall.h
//  NHShareHelper
//
//  Created by neghao on 2017/3/23.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCall.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@class FBSDKProfile,FBSDKAccessToken,FBSDKLoginManagerLoginResult;

typedef void (^NHFaceLoginManagerRequestTokenHandler)(FBSDKLoginManagerLoginResult *result, FBSDKProfile *currentProfile, NSError *error);

@interface NHFacebookCall : NHCall
@property (nonatomic, assign) id<NHCallProtocol> callDelegate;


/**
 ReadPermissions:
 [
 email — 允许访问用户的首选邮箱。
 user_likes — 允许访问用户点赞的内容列表。
 publish_actions 权限让您可以向用户的 Facebook 时间线发帖
 ]
  */

+ (void)createLoginManagerReadPermissions:(NSArray *)permissions
                            loginBehavior:(FBSDKLoginBehavior)loginBehavior
                       fromViewController:(UIViewController *)fromViewController
                                  handler:(NHFaceLoginManagerRequestTokenHandler)handler;


/**
 Call this method from the [UIApplicationDelegate application:didFinishLaunchingWithOptions:] method
 of the AppDelegate for your app. It should be invoked for the proper use of the Facebook SDK.
 As part of SDK initialization basic auto logging of app events will occur, this can be
 controlled via 'FacebookAutoLogAppEventsEnabled' key in the project info plist file.
 
 - Parameter application: The application as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].
 
 - Parameter launchOptions: The launchOptions as passed to [UIApplicationDelegate application:didFinishLaunchingWithOptions:].
 
 - Returns: YES if the url was intended for the Facebook SDK, NO if not.
 
 
 
 Indicates if `currentProfile` will automatically observe `FBSDKAccessTokenDidChangeNotification` notifications
 - Parameter enable: YES is observing
 
 If observing, this class will issue a graph request for public profile data when the current token's userID
 differs from the current profile. You can observe `FBSDKProfileDidChangeNotification` for when the profile is updated.
 
 Note that if `[FBSDKAccessToken currentAccessToken]` is unset, the `currentProfile` instance remains. It's also possible
 for `currentProfile` to return nil until the data is fetched.
 */
+ (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
        enableUpdatesOnAccessTokenChange:(BOOL)enable;

/**
 Gets the current FBSDKProfile instance.
 */
+ (FBSDKProfile *)currentProfile;

/**
 Compares the receiver to another FBSDKAccessToken
 - Parameter token: The other token
 - Returns: YES if the receiver's values are equal to the other token's values; otherwise NO
 */
- (BOOL)isEqualToAccessToken:(FBSDKAccessToken *)token;

/**
 Returns the "global" access token that represents the currently logged in user.
 
 The `currentAccessToken` is a convenient representation of the token of the
 current user and is used by other SDK components (like `FBSDKLoginManager`).
 */
+ (FBSDKAccessToken *)currentAccessToken;

/**
 Sets the "global" access token that represents the currently logged in user.
 - Parameter token: The access token to set.
 
 This will broadcast a notification and save the token to the app keychain.
 */
+ (void)setCurrentAccessToken:(FBSDKAccessToken *)token;

/**
 
 Notifies the events system that the app has launched and, when appropriate, logs an "activated app" event.
 This function is called automatically from FBSDKApplicationDelegate applicationDidBecomeActive, unless
 one overrides 'FacebookAutoLogAppEventsEnabled' key to false in the project info plist file.
 In case 'FacebookAutoLogAppEventsEnabled' is set to false, then it should typically be placed in the
 app delegates' `applicationDidBecomeActive:` method.
 
 This method also takes care of logging the event indicating the first time this app has been launched, which, among other things, is used to
 track user acquisition and app install ads conversions.
 
 
 
 `activateApp` will not log an event on every app launch, since launches happen every time the app is backgrounded and then foregrounded.
 "activated app" events will be logged when the app has not been active for more than 60 seconds.  This method also causes a "deactivated app"
 event to be logged when sessions are "completed", and these events are logged with the session length, with an indication of how much
 time has elapsed between sessions, and with the number of background/foreground interruptions that session had.  This data
 is all visible in your app's App Events Insights.
 */
+ (void)activateApp;



@end

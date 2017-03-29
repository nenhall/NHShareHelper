//
//  NHShareConfiguration.h
//  NHShareHelper
//
//  Created by NegHao.W on 17/2/16.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#include <UIKit/UIKit.h>
#import "NHSingleton.h"

//note
#define NHShareUrl       @"https://github.com/NegHao/NHShareHelper.git"
#define NHShareTitle     [NSString stringWithFormat:@"NHShareHelper，不同寻常的分享体验！"]
#define NHShareDescription(name) [NSString stringWithFormat:@"%@ 邀您一起感受Ta的分享之旅，快去看看吧~",(name)]
#define NHShareImageUrl    @"http://avatar.csdn.net/F/F/C/1_laencho.jpg"
#define NHShareImageData   UIImagePNGRepresentation([UIImage imageNamed:@"test"])


#define FacebookID     @"2437370894235"
#define AlibabaID      @"20170323063520"
//QQ参数
#define QQAppID        @"11054672"
#define QQAppKey       @"xiJ7fsMcHTAbA1el"


//微信参数
#define WXAppID        @"wx25baeb3cd821ba"
#define WXAppSecret    @"a99e53a9518d5218c9b2710c072b625e**"


//微博参数
#define WBAppID        @"34799478"
#define WBAppSecret    @"a99e53a9518d5218c9b2710c072b625e"
#define WBRedirectURL  @"http://sns.whalecloud.com"
#define WBGetTokeninfo @"https://api.weibo.com/oauth2/get_token_info"
#define WBGetUserinfo  @"https://api.weibo.com/2/users/show.json"


#define NHWindow           [UIApplication sharedApplication].delegate.window

/*****************************自定义的 NSLog******************************/
#ifdef DEBUG
#define NHNSLog(fmt, ...) NSLog((@"%s -- " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#define NHNSLog(...)
//#define NHNSLog(fmt, ...) NSLog((@"%s -- " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#endif


#define AppendString(scheme,key) [NSString stringWithFormat:@"%@%@",(scheme),(key)]

#define showTipMessage   if (1)


//分享通知名
#define NHShareResultNotification          @"ShareResultNotification"


//错误
#define ERROR_MSG(Description,FailureReason,RecoverySuggestion)  [NSDictionary dictionaryWithObjectsAndKeys:(Description),NSLocalizedDescriptionKey,\
(FailureReason),NSLocalizedFailureReasonErrorKey,\
(RecoverySuggestion),NSLocalizedRecoverySuggestionErrorKey, nil]
#define ERROR_STATUS(statusCode,info)  [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:(statusCode) userInfo:(info)]

//自定提醒窗口
NS_INLINE void NHTipWithMessage(NSString *message){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alerView show];
        [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:1.5];
    });
}

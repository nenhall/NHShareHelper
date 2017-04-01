//
//  NHShareCallTool.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHShareCallTool.h"
#import <objc/message.h>
#import "NHCallProtocol.h"
#import "NHShareConfiguration.h"

NSString * const NHWechat   = @"wx";
NSString * const NHWeiBo    = @"wb";
NSString * const NHQQ       = @"te";
NSString * const NHAlibaba  = @"ap";
NSString * const NHFacebook = @"fb";
NSString * const NHGoogle   = @"go";
NSString * const NHTwitter  = @"tw";


@interface NHShareCallTool ()<NHCallProtocol>
@property (nonatomic, strong)NSDictionary *callHelpers;
@property (nonatomic, strong)NSMutableDictionary *instanceObject;
@property (nonatomic, weak  )UIViewController *presentViewController;

@end

@implementation NHShareCallTool

static NHShareCallTool *_instance;

#pragma mark -
//MARK: 第三方注册 跳转回调
+ (instancetype)registerAppSetAppConsts:(NSArray *)appConstStrs {
    return [[NHShareCallTool sharedCallTool] registerAppSetAppConsts:appConstStrs];
}

- (instancetype)registerAppSetAppConsts:(NSArray *)appConstStrs {
    
    NSAssert(appConstStrs != nil, @"需要注册的app类型不能为空");

    for (NSString *appStr in appConstStrs) {
        @autoreleasepool {
            Class cla = NSClassFromString([_callHelpers objectForKey:appStr]);
            id obj = objc_msgSend(objc_msgSend([cla class], @selector(alloc)), @selector(init));
            if (obj != nil) {
                [self.instanceObject setObject:obj forKey:appStr];
            }

            Ivar var = class_getInstanceVariable([obj class], "_callDelegate");
            object_setIvar(obj, var, self);
            objc_msgSend(obj, @selector(callRegistApp));
        }
    }

    return [NHShareCallTool sharedCallTool];
}

//MARK: 登陆
+ (void)loginSetAppConst:(NSString *)appConstString viewController:(UIViewController *)viewController {
    [_instance loginSetAppConst:appConstString viewController:viewController];
}

- (void)loginSetAppConst:(NSString *)appConstString viewController:(UIViewController *)viewController {
    _presentViewController = viewController;
    id app = [_instanceObject objectForKey:appConstString];
    objc_msgSend(app, @selector(callLoginRequestSetViewController:), _presentViewController);
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [_instance application:application
                          openURL:url
                sourceApplication:sourceApplication
                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)application
            openURL:(nonnull NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation {
    NSLog(@"url.scheme:%@---url.host:%@",url.scheme,url.host);
    NSString *appKey = [url.scheme substringToIndex:2];
    NSString *host = url.host;
    
    if ([host isEqualToString:@"safepay"] || [host isEqualToString:@"platformapi"]) {
        appKey = @"ap";
    }
    id appOjb = [_instanceObject objectForKey:appKey];
    
    SEL sel = @selector(callApplication:openURL:sourceApplication:annotation:);
    return ((BOOL(*)(id,SEL,id,id,id,id))objc_msgSend)(appOjb, sel, application,url,sourceApplication,annotation);
    
    //    Class supc = class_getSuperclass([appOjb class]);
    //    Ivar ivar = class_getInstanceVariable([appOjb class], "_isOpenURL");
    //    NSNumber *isOpenURL = object_getIvar(appOjb, ivar);
}


#pragma mark - NHCallDelegate
//MARK: QQ \ wechat \ weibo消息回调
- (void)callType:(NHAppType)appType loginSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_loginResultAppType:Success:errorMsg:)]) {
        [self.delegate nh_loginResultAppType:appType Success:success errorMsg:errorMsg];
    }
}

- (void)callType:(NHAppType)appType shareSuccess:(BOOL)success errorMsg:(NSString *)errorMsg {
    if (self.delegate && [self.delegate respondsToSelector:@selector(nh_shareResultSuccess:errorMsg:shareType:)]) {
        [self.delegate nh_shareResultSuccess:success errorMsg:errorMsg shareType:appType];
    }
}

- (void)callType:(NHAppType)appType userinfo:(__kindof NHUserinfo *)userinfo errorMsg:(NSString *)errorMsg {
    if (appType == NHApp_QQ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nh_QQRequestUserinfo:errorMsg:)]) {
            [self.delegate nh_QQRequestUserinfo:userinfo errorMsg:errorMsg];
        }
        
    } else if (appType == NHApp_WeiBo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nh_weiBoRequestUserinfo:errorMsg:)]) {
            [self.delegate nh_weiBoRequestUserinfo:userinfo errorMsg:errorMsg];
        }
        
    } else if (appType == NHApp_Wechat) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nh_wechatRequestUserinfo:errorMsg:)]) {
            [self.delegate nh_wechatRequestUserinfo:userinfo errorMsg:errorMsg];
        }
        
    } else if (appType == NHApp_Facebook) {
    
    }
}


#pragma mark - initialize
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedCallTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        _instance.callHelpers = @{
                                  @"te" : @"NHQQCall",
                                  @"wx" : @"NHWechatCall",
                                  @"wb" : @"NHWeiBoCall",
                                  @"fb" : @"NHFacebookCall",
                                  @"ap" : @"NHAlibabaCall"
                                  };
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (instancetype)addDelegate:(id)delegate{
    self.delegate = delegate;
    return self;
}

- (NSMutableDictionary *)instanceObject {
    if (!_instanceObject) {
        _instanceObject = [[NSMutableDictionary alloc] init];
    }
    return _instanceObject;
}

//- (NHCall *)call{
//    if (!_call) {
//        _call = [[NHCall alloc] init];
////        _call.callDelegate = _instance;
//    }
//    return _call;
//}

@end

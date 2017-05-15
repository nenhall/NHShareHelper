//
//  NHAlibabaCall.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/3/29.
//  Copyright © 2017年 NegHao. All rights reserved.
//

#import "NHAlibabaCall.h"
#import "NHShareCallTool.h"
#import "NHAliAuthV2info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


#define alkey @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDYtP8YctbktjTMCEq/8uZcG9m/i/yYR+fyOVimVeTn2fBoFE11tpWvLNhYV3PXhQ7OequBnoxp6lrrE0UQ+oirnfRsd/eQFjVrkd59ACNAbInsrvsXBNiu6nUoJQTPP7VmLVD5077ct5X68aYvEuz7CdlaUoLtRFz60rfs56E2ykI+HfO3UBFkK3tITq5lJ0zpVLdmfyqaoS/7j7pglOoRPSDA+F1pB3ClbSJyVwF+G6q+wbXj0+eW9EJ0zoCkr7VxGEgnT3HJRHUsjNXx07UzJgYxtvNGCMRqi8tXb8h1kWRODSuikJEvwcRCqbVj+lepSPi0+jFvn2nu1u7R8JmdAgMBAAECggEBAKbStuoIRdutVHmZDIo1oBZaLkdhqWNFP45djRwHVX8SbBqDPpoWo6ZF3IotUHUh7iMPlgXjmu5SRglfPTTz2NBceXQi6kZWgms70M3jlD+dDpRQo+S1i2UkAmqUDN7KiYeN7R9VXUGmZmPXMPpeFGawz0zT5gxnKzi/jG1oZte4cqMn7nxHduIVYGEe5KqNkySsqTNRNvxbiLYEwWna1mW9mIt/KdLDkQEZobl4h4go+aqiJhV/UTI8Y6pLyXDPONQ3BN5hvdk+Q/JRkCj9pDp6STSJEBD8bYTh3kY8xBe9LkvgQ7oG6f/l/IEXi8D9lLsv5z2rjKOLyCJwDd6eGDUCgYEA/ZVj63LdwmLJzJFl3VZhIA83Ymvl2071rWKeloJrEHi8SI0vwaeFI0FuLfnt9ulAZv6dXgDpP9rBdWH4lRYZd/pLr7aQ63NVCbNo62xtE1AMRUv9mGwqV3GIMoXKYC8v4TlLEE+mdq5S4Xr2CsE2p+ixjzSs8NUGumQrnong9vMCgYEA2sWlnD7/PppKzOihZJGCrJwWkt6RE+tK3v8RkTwUxTWoRmI23WBPZMtuTgUU+LJGOaju8YvI9CfDmtm2dMgMlpSfCJV9HJa7ijhW/F1GX9cfcDFQQR6Pr6/nDwXInFQyV4DYvWSw+kubFJK3aYAQq0nFIkLamTrb2Y9tiIVWcS8CgYAYETGmiwRZCp80dyg/1Y7qSAdto+fw5JGUnyOGDWKz8YGNMTkzG/8a1X7rhij7oi+mlsvAvD1m/hAWX/ID1FEeffbo+l7Oued8QDbZATVo+9PuT8QFz15FZlUS1nfaoR/eNF3XcnfOE8Vx+QWZB7V0QjV37fvr74vv7MnnBhb/2QKBgD1HQWUrjClH5I3S12opC/Y3XmdTKkXvETC3N3972cGHjxPv7LhDgtmT1djKuZ4TqXH7LLrB0c752GNmeiHp6wS+qnEoFjxMyEkmEM9tfQnZYvf1CCrFWa/3UHw3vYJ0Xwl9kLg0HRJu3Qh9NBy7/29LIYnAOiTThMNC1oZ3+seHAoGANNAjN4u3I7yn8QpjXhyYEepqAwcAHtgolNJzWYw9HN0n5UpY1owSGTAi0E87GFy7g0Q/h/lm5SwkvB0xEFtF25QubImd4Dx38LhTBqPzaAIqBgU+vh7v92VnmFqgUOGsjVUI0mrRNzSa7XAKNFEXsvuG6HciUxFPOpKQbvwAuSE="


@interface NHAlibabaCall ()<APOpenAPIDelegate>

@end

@implementation NHAlibabaCall
NSSingletonM(call);

- (BOOL)callRegistApp {
    return [APOpenAPI registerApp:AlibabaID];
}

- (void)callLoginRequestSetViewController:(UIViewController *)viewController {
    [_instance alipayAuth];
}

- (BOOL)callApplication:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"platformapi"]) {
      return [APOpenAPI handleOpenURL:url delegate:self];
    }
    __weak __block typeof(self)weakself = self;
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NHNSLog(@"result1111 = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付 处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NHNSLog(@"result2222 = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
           
            NHNSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];

        
    }
    return YES;
}


#pragma mark - =============== APOpenAPIDelegate ===============
//MARK: =============== APOpenAPIDelegate ===============
- (void)onReq:(APBaseReq *)req {
    NHNSLog(@"");
}

- (void)onResp:(APBaseResp *)resp {
    
    APSendMessageToAPResp *subResp = (APSendMessageToAPResp *)resp;
    
    switch (subResp.errCode) {
        case APSuccess:
            //  成功
            break;
        case APErrCodeCommon:
            //  通用错误
            break;
        case APErrCodeUserCancel:
            //  用户取消
            break;
        case APErrCodeSentFail:
            //  发送失败
            break;
        case APErrCodeAuthDeny:
            //  授权失败
            break;
        case APErrCodeUnsupport:
            //  不支持
            break;
        default:
            break;
    }
    NHTipWithMessage(subResp.errStr);
    NHNSLog(@"%@-%d-%@",subResp.errStr,subResp.errCode,subResp.openID);
    
    if (_callDelegate && [_callDelegate respondsToSelector:@selector(callType:shareSuccess:errorMsg:)]) {
        [_callDelegate callType:NHApp_Alibaba shareSuccess:subResp.errCode errorMsg:subResp.errStr];
    }
}


#pragma mark - =============== 授权相关 ===============
//MARK: =============== 授权相关 ===============
- (void)alipayAuth2 {
    //appid
    //商户id
    NSString *pid = @"2088621832374680";
    
    
    //私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    //配置密钥:https://doc.open.alipay.com/doc2/detail.htm?treeId=204&articleId=105297&docType=1#s1
    NSString *rsa2PrivateKey = alkey;
    NSString *rsaPrivateKey = @"";
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [AlibabaID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
        {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
        }
    
    //生成 auth info 对象
    NHAliAuthV2info *authInfo = [NHAliAuthV2info new];
    authInfo.pid = pid;
    authInfo.appID = AlibabaID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"ap2017032306355520";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NHNSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:authInfoStr withRSA2:YES];
    } else {
        signedString = [signer signString:authInfoStr withRSA2:NO];
    }
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    __weak __block typeof(self)weakself = self;
    
    if (signedString.length > 0) {
        NSString *rsaType = (rsa2PrivateKey.length > 1) ? @"RSA2":@"RSA";
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, rsaType];
        
        //ap2017032306355520
        APayAuthInfo *info = [[APayAuthInfo alloc] initWithAppID:AlibabaID pid:pid redirectUri:@"ap2017032306355520"];
        
        [[AlipaySDK defaultService] authWithInfo:info callback:^(NSDictionary *resultDic) {
            NHNSLog(@"快登结果 resultDic = %@", resultDic);
        }];
    }

}

- (void)alipayAuth{
    
    //appid
    //商户id
    NSString *pid = @"2088621832374680";
    
    
    //私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    //配置密钥:https://doc.open.alipay.com/doc2/detail.htm?treeId=204&articleId=105297&docType=1#s1
    NSString *rsa2PrivateKey = alkey;
    NSString *rsaPrivateKey = @"";
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [AlibabaID length] == 0 ||
        ([rsa2PrivateKey length] == 0 && [rsaPrivateKey length] == 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少pid或者appID或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //生成 auth info 对象
    NHAliAuthV2info *authInfo = [NHAliAuthV2info new];
    authInfo.pid = pid;
    authInfo.appID = AlibabaID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"mijialive";
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NHNSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:authInfoStr withRSA2:YES];
    } else {
        signedString = [signer signString:authInfoStr withRSA2:NO];
    }
    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    __weak __block typeof(self)weakself = self;

    if (signedString.length > 0) {
        NSString *rsaType = (rsa2PrivateKey.length > 1) ? @"RSA2":@"RSA";
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, rsaType];
        
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic)
        {
         /**
         {
         memo = "";
         result = "success=true&auth_code=7404f97d7c8c45919b3f460b28e7OE56&result_code=200&alipay_open_id=20880047939342960822699332410756&user_id=2088702023078560";
         resultStatus = 9000;
         }
         
         状态码（resultStatus）	状态描述
         9000	请求处理成功
         4000	系统异常
         6001	用户中途取消
         6002	网络连接出错
         
         状态码（result_code）	状态描述
         200	业务处理成功，会返回authCode
         1005	账户已冻结，如有疑问，请联系支付宝技术支持
         202	系统异常，请稍后再试或联系支付宝技术支持
         
         app_id=&method=&format=&charset=&sign_type=&sign=&timestamp=&version=&auth_token=&app_auth_token=
         */
            NHNSLog(@"result = %@",resultDic);
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
        NHTipWithMessage([NSString stringWithFormat:@"授权结果 authCode = %@",authCode]);
        if (weakself.callDelegate && [weakself.callDelegate respondsToSelector:@selector(callType:loginSuccess:errorMsg:)]) {
            [weakself.callDelegate callType:NHApp_Alibaba
                               loginSuccess:authCode == nil ? NO : YES
                                   errorMsg:[resultDic objectForKey:@"result_code"]];
        }
        
        if (weakself.callDelegate && [weakself.callDelegate respondsToSelector:@selector(callType:userinfo:errorMsg:)]) {
            [weakself.callDelegate callType:NHApp_Alibaba
                                   userinfo:[resultDic objectForKey:@"auth_code"]
                                   errorMsg:[resultDic objectForKey:@"result_code"]];
        }
            NHNSLog(@"授权结果 authCode = %@", authCode?:@"");
        NSLog(@"[[AlipaySDK defaultService] fetchTradeToken]:%@",[[AlipaySDK defaultService] fetchTradeToken]);

        }];
    
        //670f34ecfb1848478bc8491b0746TX56
        //46d72f67931f47d085bf7b5ab43fSX56
    }
}




#pragma mark - =============== 分享相关 ===============
//MARK: =============== 分享相关 ===============
//文本消息
+ (void)sendMessageText:(NSString *)text scene:(APScene)scene {
    [_instance sendMessageText:text scene:scene];
}
- (void)sendMessageText:(NSString *)text scene:(APScene)scene {
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = newMediaMessage(newTextObject(text));
    
    //  发送请求，返回接口调用结果，用户操作行为结果通过接收响应消息获得，后面详解
    BOOL result = [APOpenAPI sendReq:newSendMessageToAPReq(message, 1)];
    if (!result) {
        //失败处理....
    }
}

//图片消息(image)
+ (void)sendPhotoByUrlString:(NSString *)urlStr scene:(APScene)scene {
    [_instance sendPhotoByUrlString:urlStr scene:scene];
}
- (void)sendPhotoByUrlString:(NSString *)urlStr scene:(APScene)scene {

    APMediaMessage *message = newMediaMessage(newImageObject(nil, urlStr));
    
    //  发送请求
    BOOL result = [APOpenAPI sendReq:newSendMessageToAPReq(message, scene)];
    if (!result) {
        //失败处理
        NHNSLog(@"发送失败");
    }
}

//图片消息(data)
+ (void)sendPhotoByData:(NSData *)data scene:(APScene)scene {
    [_instance sendPhotoByData:data scene:scene];
}
- (void)sendPhotoByData:(NSData *)data scene:(APScene)scene {
    //  创建消息载体 APMediaMessage 对象
    //  此处必须填充有效的image NSData类型数据，否则无法正常分享
    APMediaMessage *message = newMediaMessage(newImageObject(data, nil));
    
    //  发送请求
    BOOL result = [APOpenAPI sendReq:newSendMessageToAPReq(message, scene)];
    if (!result) {
        //失败处理
        NHNSLog(@"发送失败");
    }
}

//  发送网页消息到支付宝(缩略图链接形式)
+ (void)sendWebByUrlString:(NSString *)urlStr
                     title:(NSString *)title
               description:(NSString *)description
                  thumbUrl:(NSString *)thumbUrl
                     scene:(APScene)scene {
    [_instance sendWebByUrlString:urlStr title:title description:description thumbUrl:thumbUrl scene:scene];
}
- (void)sendWebByUrlString:(NSString *)urlStr
                     title:(NSString *)title
               description:(NSString *)description
                  thumbUrl:(NSString *)thumbUrl
                     scene:(APScene)scene {
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = newMediaMessage(newWebObject(urlStr));
    message.title = title;
    message.desc = description;
    message.thumbUrl = thumbUrl;

    //  发送请求
    BOOL result = [APOpenAPI sendReq:newSendMessageToAPReq(message, scene)];
    if (!result) {
        //失败处理
        NHNSLog(@"发送失败");
    }
}

//  发送网页消息到支付宝(缩略图链接形式)
+ (void)sendWebByData:(NSData *)data
            urlString:(NSString *)urlStr
                title:(NSString *)title
          description:(NSString *)description
                scene:(APScene)scene {
    [_instance sendWebByData:data urlString:urlStr title:title description:description scene:scene];
}
- (void)sendWebByData:(NSData *)data
            urlString:(NSString *)urlStr
                title:(NSString *)title
          description:(NSString *)description
                scene:(APScene)scene {
    //  创建消息载体 APMediaMessage 对象
    APMediaMessage *message = newMediaMessage(newWebObject(urlStr));
    message.title = title;
    message.desc = description;

    //  此处必须填充有效的image NSData类型数据，否则无法正常分享
    message.thumbData = data;
    
    //  发送请求
    BOOL result = [APOpenAPI sendReq:newSendMessageToAPReq(message, scene)];
    if (!result) {
        //失败处理
        NHNSLog(@"发送失败");
    }
}


#pragma mark - initailze
#pragma mark -
APMediaMessage *newMediaMessage(id mediaObject) {
    APMediaMessage *message = [[APMediaMessage alloc] init];
    message.mediaObject = mediaObject;
    return message;
}

//  创建文本类型的消息对象
APShareTextObject *newTextObject(NSString *text){
    APShareTextObject *textObj = [[APShareTextObject alloc] init];
    textObj.text = text;
    return textObj;
}


APShareImageObject *newImageObject(NSData *imageData, NSString *imageUrl){
    APShareImageObject *imgObj = [[APShareImageObject alloc] init];
    imgObj.imageData = imageData;
    imgObj.imageUrl = imageUrl;
    return imgObj;
}

APShareWebObject *newWebObject(NSString *wepageUrl) {
    APShareWebObject *webObj = [[APShareWebObject alloc] init];
    webObj.wepageUrl = wepageUrl;
    return webObj;
}

APSendMessageToAPReq *newSendMessageToAPReq(APMediaMessage* message, APScene scene) {
    //  创建发送请求对象
    APSendMessageToAPReq *request = [[APSendMessageToAPReq alloc] init];
    //  填充消息载体对象
    request.message = message;
    //  分享场景，0为分享到好友，1为分享到生活圈；支付宝9.9.5版本至现在版本，分享入口已合并，这个scene并没有被使用，用户会在跳转进支付宝后选择分享场景（好友、动态、圈子等），但为保证老版本上无问题、建议还是照常传入
    request.scene = scene;
    
    return request;
}

@end

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


#define alkey @"MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCkCeC56gs5XhLaeYnIpTAzgTL31wWm6WAlqjDiL7KCyAkMJzdoEDGl4tasqpxHZHbh2qmIaSk86huWRd/ETsV2Ew8gsyIoXHdEIyJ/nPTMQSlTcrJnW+5ue5hGe+NmjV0nkMCZPMDTr2uEqiKO2XV89tpzFPdein55Ka/paYvrXN9Uoo+3UCc6XF6daHg3quCGP5Gj61koJ4P8RFvS2RQWORTspsAnd315fQXl+loFlt6Xl6HblPcZcoXUVyfTgwPI7qZdKYoBSGgxS6cnEu678qnXr498hoQ/jzGlex/J2owsjeJoBVyFK6SZm7P15OxhFlRFpayAU0IdfWoKWgO7AgMBAAECggEALzqc1kpZYvH/8aEul3NgFmQrfYoOGYl14kJHAsiC1/6qBDLCVBbdhIp0DpCsoC1/wPVI/HpyohQxTyndDFM1rRI9t8d7nS1KNXb8NsvE+44DTQBn9zRTyMGTDTAcP+mRmZOmsDf6uLf39+FYQ9K+bfVQ3fN6aWDsmwvylvyJiYDioPRj1tbgLbTnz4p43Cey0OG0nOvl7OVEG1gKUx4hjWAbPcX8+UtfdxpJ6Nd/zqPxdXL6K1AAdH7XgqYxsddPKRDRjbv20arLi24J53x7Sm1cSdkut8fPvjVf6ESyfzNYUKRd1r1UnsvH5SwPcllRG5om7n+MNo1S3dJfoO9ycQKBgQD4o6a7IfXLRiOpyVXB2So0bKln86J0yqFZJI7t0q1eJkTQKNUxzZAIIPOg42+TAwgArwSrNL1p7rUKL1avd08LaygTWVikv6FUcXyECfeDzgysJi7RrvDhYiAf2RZu5HL1toHAGLiBlDwzfWzmgc/364Td95Ub9p/mkArRCPHo8wKBgQCo5RFrLTAK8yKOwLH8dmaHUywg1ZL4n749nINNpAQV1lEWU3ApDe/AT9fr6DdUg6dTwvyoSJMYKAzBlyrShwjhcjjGWIXSEFdMieKTEDaHLXA+sO07GM6/QssDVzEAyAUqAUBf+KvSKVQuxFllLwqcSXUnVblDbxoAZ+rdcq2sGQKBgA/REUUsNt+UeaZOWXc4YlftZaVoOThmv3bVPYZhdYfctVnsjwtZAUWTGwxsC2f1tGeeupRNiZMYjUm1kzUcSNn4GheJAnuQeSnPAlW/8I/g5qt4zlemYkpkHJkKDURGog2Ba6WVrP8JN/8qhmfvcBRcVhpsqn6Z5LgdB6Meh40DAoGAV52tsZnZiHSlAsU4EC4j9iPRip8BBXVpLXEaNJbXf7SUkC5syv9t1qgU7U6kFXXOwgcvJuWvWSK9q1gOYPSoSLwGc+7MTTMo9o25Om14vBt4VS1XhAbUiifORUdgJnWdKDNJ//9ysy25fCFj9re2m2kIG4W+/BqQtJE0J/kr21ECgYAUGTd0UHv8SHJT1kcCHitMFl/ILzEHemSpqSeddP/j+iRhxbwjHoLBHpyKZhNqgL44G5PsajsYh2piV03xxQfuxGeAO+KcM9ikB9LrQQjEmG938III4779VXF0cDpqmNmSvMi6lIzc4U7oMezZe1AKESCvZyq2PgiA80fO6mc4Yw=="


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
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NHNSLog(@"result1111 = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
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
- (void)alipayAuth{

    //商户id
    NSString *pid = @"2088102169625619";
    //appid
    NSString *appID = @"2017032306355520";
    
    //私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    //配置密钥:https://doc.open.alipay.com/doc2/detail.htm?treeId=204&articleId=105297&docType=1#s1
    NSString *rsa2PrivateKey = alkey;
    NSString *rsaPrivateKey = @"";
    
    //pid和appID获取失败,提示
    if ([pid length] == 0 ||
        [appID length] == 0 ||
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
    authInfo.appID = appID;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"com.neghao.share";
    
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
    if (signedString.length > 0) {
        NSString *rsaType = (rsa2PrivateKey.length > 1) ? @"RSA2":@"RSA";
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, rsaType];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic)
        {
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
            NHNSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
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

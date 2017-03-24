//
//  NHWeiBoCall.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHWeiBoCall.h"
#import "NHShareConfiguration.h"

@interface NHWeiBoCall ()<WeiboSDKDelegate,WBHttpRequestDelegate>
@property (nonatomic, copy  ) NSString *open_id;
@property (nonatomic, copy  ) NSString *user_id;
@property (nonatomic, copy  ) NSString *access_token;
@property (nonatomic, copy  ) NSString *refresh_token;
@property (nonatomic, strong) WBHttpRequest *wbHttpRequest;
@property (nonatomic, strong) NHWeiBoUserinfo *weiBoUserinfo;
@end

@implementation NHWeiBoCall
NSSingletonM(NHWeiBoCall);

- (BOOL)handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)weiboRegistWithAppID:(NSString *)appID{
    [WeiboSDK enableDebugMode:YES];
    return [WeiboSDK registerApp:appID];
}
- (void)weiboLoginRequest{
    [WeiboSDK sendRequest:[self weiboAuthorize]];
}

/**
 *  微博的登出
 */
- (void)weiboLogOutRequest{
    [WeiboSDK logOutWithToken:_access_token delegate:self withTag:@"user"];
}

/** 微博授权类*/
- (WBAuthorizeRequest *)weiboAuthorize{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WBRedirectURL;
    request.scope = @"all";
    return request;
}


/**
 *  微博分享
 */
+ (void)sendRequestWithCompereName:(NSString *)compereName
                     thumbnailData:(NSData *)thumbnailData
                        webpageUrl:(NSString *)webpageUrl
{
    [[NHWeiBoCall sharedNHWeiBoCall] sendRequestWithCompereName:compereName
                                                  thumbnailData:thumbnailData
                                                     webpageUrl:webpageUrl];
}

- (void)sendRequestWithCompereName:(NSString *)compereName
                     thumbnailData:(NSData *)thumbnailData
                        webpageUrl:(NSString *)webpageUrl
{
    WBMessageObject *message = [WBMessageObject message];
    NSString *string = [NSString stringWithFormat:@"%@\n%@",NHShareTitle,NHShareDescription(compereName)];
    message.text = [NSString stringWithFormat:@"%@：%@",string,webpageUrl];
    
    WBImageObject *image = [WBImageObject object];
    image.imageData = thumbnailData;
    message.imageObject = image;
    
    /**
     WBWebpageObject *webpage = [WBWebpageObject object];
     webpage.objectID = @"中国直播";
     webpage.title = @"我在中国直播！";
     webpage.description = @"我在中国直播，大家快来围观！";
     webpage.thumbnailData = kGetLocalUserinfo(kLocal_key_HeadPicData);
     webpage.webpageUrl = webpageUrl;
     message.mediaObject = webpage;
     */
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message
                                                                                  authInfo:[self weiboAuthorize]
                                                                              access_token:_access_token];
    [WeiboSDK sendRequest:request];
}


/**
 *  登录或分享回来
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{

    BOOL success = NO;
    NSString *resultStr;
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {//分享发送结果
        WBSendMessageToWeiboResponse *wResponse = (WBSendMessageToWeiboResponse *)response;
        NSString* accessToken = [wResponse.authResponse accessToken];
        if (accessToken)
        {
            _access_token = accessToken;
        }
        _user_id = [wResponse.authResponse userID];
        switch (wResponse.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:
                success = YES;
                break;
            case WeiboSDKResponseStatusCodeUserCancel:
                resultStr = @"用户取消发送";
                break;
            case WeiboSDKResponseStatusCodeUnsupport:
                resultStr = @"不支持的请求";
                break;
            case WeiboSDKResponseStatusCodeSentFail:
                resultStr = @"发送失败";
                break;
            case WeiboSDKResponseStatusCodeAuthDeny:
                resultStr = @"授权失败";
                break;
            case WeiboSDKResponseStatusCodeShareInSDKFailed:
                resultStr = @"分享失败 详情见response UserInfo";
                break;
            default :
                resultStr = @"分享失败，微博发生一个未知错误！";
                break;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(weiBoShareResultSuccess:errorMsg:)]) {
            [self.delegate weiBoShareResultSuccess:success errorMsg:resultStr];
        }
        
    }else if ([response isKindOfClass:WBAuthorizeResponse.class]){//登录认证结果
        if (response.statusCode == 0) {
            success = YES;
            resultStr = @"登录成功";
            _access_token = [(WBAuthorizeResponse *)response accessToken];
            _open_id = [(WBAuthorizeResponse *)response userID];
            _refresh_token = [(WBAuthorizeResponse *)response refreshToken];

            [self questWeiboUserinfo:[(WBAuthorizeResponse *)response accessToken] openID:[(WBAuthorizeResponse *)response userID]];
            
        } else if (response.statusCode == -1) {
            resultStr = @"你取消了授权/分享";
        } else if (response.statusCode == -3){
            resultStr = @"授权失败";
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(weiBoLoginResultSuccess:errorMsg:)]) {
            [self.delegate weiBoLoginResultSuccess:success errorMsg:resultStr];
        }
        
    }else if ([response isKindOfClass:WBShareMessageToContactResponse.class]){//发送结果
        
    }
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NHNSLog(@"%@",request);
}


/** 在token没有失效的情况下，请求用户信息*/
- (void)questWeiboUserinfo:(NSString *)access_token openID:(NSString *)openID{
    
    //获取用户的粉丝数、关注数、微博数,根据微博开放平台获取此数据必须需要access_token,uids
    NSArray *value=[NSArray arrayWithObjects:access_token,openID,nil];
    NSArray *key=[NSArray arrayWithObjects:@"access_token",@"uid", nil];
    NSDictionary *parameters=[[NSDictionary alloc]initWithObjects:value forKeys:key];
    //发送请求 获取各种数据
    _wbHttpRequest = [WBHttpRequest requestWithURL:WBGetUserinfo httpMethod:@"GET" params:parameters delegate:self withTag:@"getUserInfo"];
}

-  (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    NSData  *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    _weiBoUserinfo = [[NHWeiBoUserinfo alloc] init];
    [_weiBoUserinfo setValuesForKeysWithDictionary:info];
    NHNSLog(@"WBHttpRequest:%@---%@",request,info);
    if (self.delegate && [self.delegate respondsToSelector:@selector(weiBoRequestUserinfo:error:)]) {
        [self.delegate weiBoRequestUserinfo:_weiBoUserinfo error:nil];
    }
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(weiBoRequestUserinfo:error:)]) {
        [self.delegate weiBoRequestUserinfo:_weiBoUserinfo error:error];
    }
}


@end

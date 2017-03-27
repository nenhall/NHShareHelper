//
//  NHQQCall.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHQQCall.h"
#import "NHSingleton.h"
#import "NHShareConfiguration.h"


@interface NHQQCall ()
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, copy  ) NSArray  *permissions;
@property (nonatomic, copy  ) NSString *openId;
@property (nonatomic, copy  ) NSString *accessToken;
/** Access Token的失效期 */
@property (nonatomic, strong) NSDate   *expirationDate;

@end

@implementation NHQQCall
//NSSingletonM(QQCall)


/**
 *  QQ注册
 */
- (BOOL)callRegistApp {
    if (_tencentOAuth == nil) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppID andDelegate:self];
        //        _tencentOAuth.redirectURI =  @"www.qq.com";
        [self configuration];

    }
    return YES;
}

- (void)configuration {

    _permissions = [NSArray arrayWithObjects:
                    kOPEN_PERMISSION_GET_USER_INFO,
                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                    kOPEN_PERMISSION_GET_INFO,
                    kOPEN_PERMISSION_ADD_TOPIC,
                    kOPEN_PERMISSION_ADD_ONE_BLOG,
                    kOPEN_PERMISSION_ADD_SHARE,nil];
}

/**
 *  QQ登录请求
 */
- (void)callLoginRequestSetViewController:(UIViewController *)viewController {
    [self.tencentOAuth authorize:_permissions inSafari:YES];
}


- (BOOL)callApplication:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation {
    [QQApiInterface handleOpenURL:url delegate:self];
    return  [TencentOAuth HandleOpenURL:url];
}

#pragma mark - 登录结果
/**
 第三方网站可存储access token信息，以便后续调用OpenAPI访问和修改用户信息时使用。
 如果需要保存授权信息，需要保存登录完成后返回的accessToken，openid 和 expirationDate三个数据，
 下次登录的时候直接将这三个数据是设置到TencentOAuth对象中即可。
 获得：
 [_tencentOAuth accessToken] ;
 [_tencentOAuth openId] ;
 [_tencentOAuth expirationDate] ;
 设置：
 [_tencentOAuth setAccessToken:accessToken] ;
 [_tencentOAuth setOpenId:openId] ;
 [_tencentOAuth setExpirationDate:expirationDate] ;
 */


//登录成功
- (void)tencentDidLogin {
    BOOL result = YES;
    NSString *error;
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //记录登录用户的OpenID、Token以及过期时间
        _accessToken = _tencentOAuth.accessToken;
        _openId = [_tencentOAuth openId];
        _expirationDate = [_tencentOAuth expirationDate];
        
        //YES表示API调用成功，NO表示API调用失败
        BOOL isGetUserinfo = [_tencentOAuth getUserInfo];
        if (!isGetUserinfo) {
            if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:userinfo:errorMsg:)]) {
                [self.callDelegate callType:NHApp_QQ userinfo:nil errorMsg:@"调用获取用户信息API失败！"];
            }
            NHNSLog(@"调用获取用户信息API失败！");
        }
        
    }else{
        //@"登录不成功 没有获取accesstoken";
        result = NO;
        error = @"没有获取accesstoken";
    }
    if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:loginSuccess:errorMsg:)]) {
        [self.callDelegate callType:NHApp_QQ loginSuccess:result errorMsg:error];
    }
}

//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSString *info;
    if (cancelled){
        info = @"用户取消登录";
    }else{
        info = @"登录失败";
    }
    if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:loginSuccess:errorMsg:)]) {
        [self.callDelegate callType:NHApp_QQ loginSuccess:NO errorMsg:info];
    }
}

//网络错误导致登录失败
-(void)tencentDidNotNetWork
{
    if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:loginSuccess:errorMsg:)]) {
        [self.callDelegate callType:NHApp_QQ loginSuccess:NO errorMsg:@"无网络连接，请检查网络"];
    }
    //    _labelTitle.text=@"无网络连接，请设置网络";
}

//已经QQ退出登录
-(void)tencentDidLogout{

}



#pragma mark - 获取用户信息的回调
#pragma mark -
//可以通过response获取数据的返回结果
- (void)getUserInfoResponse:(APIResponse*)response{
    NHNSLog(@"%s---\nQQ用户信息%@",__func__,response.jsonResponse);
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode)
    {
        //保存用户信息
        _QQUserinfo = [[NHQQUserinfo alloc] init];
        [_QQUserinfo setValuesForKeysWithDictionary:response.jsonResponse];
        
    }else{
        [self showErrorinfoWith:response];
    }
    
    
    if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:userinfo:errorMsg:)]) {
        [self.callDelegate callType:NHApp_QQ userinfo:_QQUserinfo errorMsg:response.errorMsg];
    }
}

+ (void)sendCompereName:(NSString *)compereName
                 urlStr:(NSString *)urlStr
            description:(NSString *)description
          previewImgURL:(NSString *)previewImgURL
              shareType:(NHQQShareType)shareType
{
    [[[self alloc] init] sendCompereName:compereName
                                  urlStr:urlStr
                             description:description
                           previewImgURL:previewImgURL
                               shareType:shareType];
}

- (void)sendCompereName:(NSString *)compereName
                 urlStr:(NSString *)urlStr
            description:(NSString *)description
          previewImgURL:(NSString *)previewImgURL
              shareType:(NHQQShareType)shareType
{
    //    NHNSLog(@"判断登录态是否有效:%d",[_tencentOAuth isSessionValid]);
    [self createNewsObjectWithUrlStr:urlStr
                         compereName:compereName
                         description:description
                       previewImgURL:previewImgURL
                            setCflag:shareType];
}


/**
 *  创建QQ信息对象
 */
- (QQApiNewsObject *)createNewsObjectWithUrlStr:(NSString *)urlStr compereName:(NSString *)compereName description:(NSString *)description previewImgURL:(NSString *)previewImgURL setCflag:(uint64_t)flag{
    
    NSString *descriptions = NHShareDescription(compereName);
    NSString *title = NHShareUrl;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURL *previewURL = [NSURL URLWithString:previewImgURL];
    
    QQApiNewsObject* newsObj = [QQApiNewsObject objectWithURL:url title:title description:description ? : descriptions previewImageURL:previewURL];
    [newsObj setCflag:flag];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
    return newsObj;
}

-(NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams {
    NHNSLog(@"%s---permissions:%@",__func__,permissions);
    return _permissions;
}

//QQ分享后的回调结果
- (void)onResp:(QQBaseResp *)resp{
    // SendMessageToQQResp应答帮助类
    if ([resp.class isSubclassOfClass: [SendMessageToQQResp class]]) {  //QQ分享回应
        SendMessageToQQResp *msg = (SendMessageToQQResp *)resp;
//        msg.result == 0 成功
//        egLog: QQ分享后的回调结果：code 0  errorDescription (null)  infoType (null)
        if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:shareSuccess:errorMsg:)]) {
            BOOL result = YES;
            if (![msg.result isEqualToString:@"0"]) {
                result = NO;
            }
            [self.callDelegate callType:NHApp_QQ shareSuccess:result errorMsg:msg.errorDescription];
        }
        NHNSLog(@"QQ分享后的回调结果：code %@  errorDescription %@  infoType %@",msg.result,msg.errorDescription,msg.extendInfo);
    }
}


-(BOOL)onTencentResp:(TencentApiResp *)resp{
    NHNSLog(@"%s---%@",__func__,resp);
    return YES;
}


- (BOOL)onTencentReq:(TencentApiReq *)req{
    NSArray *array = [req arrMessage];
    for (id __strong obj in array)
    {
        if ([obj isKindOfClass:[TencentTextMessageObjV1 class]])
        {
            obj = (TencentTextMessageObjV1 *)obj;
            [obj setSText:@"test"];
        }
        if ([obj isKindOfClass:[TencentImageMessageObjV1 class]])
        {
            obj = (TencentImageMessageObjV1 *)obj;
            NSString *path = [NSString stringWithFormat:@"%@/qzone0.jpg",
                              [[NSBundle mainBundle] resourcePath]];
            UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
            NSData *data = UIImageJPEGRepresentation(image, 1.0f);
            [obj setDataImage:data];
        }
        if ([obj isKindOfClass:[TencentVideoMessageV1 class]])
        {
            //请加入一段视频URL
            obj = (TencentVideoMessageV1 *)obj;
            [obj setSUrl:@" http://www.tudou.com/programs/view/_cVM3aAp270/"];
        }
    }
    TencentApiResp *resp = [TencentApiResp respFromReq:req];
    TencentApiRetCode ret = [TencentApiInterface sendRespMessageToTencentApp:resp];
    return YES;
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装QQ" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {//API接口不支持
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未发现QQ客户端" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}


- (void)showSuccessinfoWith:(APIResponse *)response{
    NSMutableString *str = [NSMutableString stringWithFormat:@""];
    for (id key in response.jsonResponse) {
        [str appendString: [NSString stringWithFormat:
                            @"%@:%@\n", key, [response.jsonResponse objectForKey:key]]];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功"
                                                    message:[NSString stringWithFormat:@"%@",str]
                                                   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
    [alert show];
}


- (void)showErrorinfoWith:(APIResponse *)response{
    NSString *errMsg = [NSString stringWithFormat:@"errorMsg:%@\n%@",
                        response.errorMsg, [response.jsonResponse objectForKey:@"msg"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败"
                                                    message:errMsg
                                                   delegate:self
                                          cancelButtonTitle:@"我知道啦"
                                          otherButtonTitles: nil];
    [alert show];
}

@end

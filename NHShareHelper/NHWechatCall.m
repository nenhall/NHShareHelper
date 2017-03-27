//
//  NHWechatCall.m
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//
//Build Setting，在"Other Linker Flags"中加入"-Objc -all_load"

#import "NHWechatCall.h"
#import "NHApiRequestHelper.h"


@class NHShareCallTool;
@interface NHWechatCall ()
@property (nonatomic, copy  ) NSArray  *permissions;
@property (nonatomic, copy  ) NSString *open_id;
@property (nonatomic, copy  ) NSString *access_token;
@property (nonatomic, copy  ) NSString *refresh_token;

/** Access Token的失效期 */
@property (nonatomic, strong) NSDate   *expirationDate;
@end

@implementation NHWechatCall

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (BOOL)callRegistApp {
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT
    | MMAPP_SUPPORT_PICTURE
    | MMAPP_SUPPORT_LOCATION
    | MMAPP_SUPPORT_VIDEO
    | MMAPP_SUPPORT_AUDIO
    | MMAPP_SUPPORT_WEBPAGE;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
   return [WXApi registerApp:WXAppID];
}


- (void)callLoginRequestSetViewController:(UIViewController *)viewController {
    //构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    
    //官方注释,有以下几个可选:@"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
    req.scope = @"snsapi_userinfo";
    
    //本应用唯一的标示符
    req.state = @"com.neghao.share";
    
    //向微信终端发送一个SendAuthReq消息结构
    [WXApi sendAuthReq:req
        viewController:viewController ?: NHWindow.rootViewController
              delegate:self];
}


/**
 *  打开微信后的回调
 */
- (BOOL)callApplication:(UIApplication *)application
                openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

/**
 *  onReq是微信终端向第三方程序发起请求，要求第三方程序响应。
 第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
 */
- (void)onReq:(BaseReq *)req{

}


/**
 *  向微信发送消息后的回调
 *  如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
 */
- (void)onResp:(BaseResp *)resp{
    NHNSLog(@"resp =%@   code = %d   type = %d",resp,resp.errCode,resp.type);
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //授权结果
        [self completeAuth:(SendAuthResp *)resp];
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        //分享结果
        [self completeShare:(SendMessageToWXResp *)resp];
    }else{
//        [MBProgressHUD showAutoMessage:@"微信处理失败，请重试"];
    }
}


/**
 *  授权登录操作：获取code、access_token、openid、userinfo
 */
- (void)completeAuth:(SendAuthResp *)resp{
    if (resp.errCode == NHWXAUTH_CODE_CANCEL || resp.errCode == NHWXAUTH_CODE_DENIED) {
        showTipMessage NHTipWithMessage(@"登录失败，你取消了授权！");
        return;
    }else if (resp.errCode == NHWXAUTH_CODE_UNSUPPORT){
        showTipMessage NHTipWithMessage(@"微信不支持！");
        return;
    };

    //获取token
    [NHApiRequestHelper getWXTokenWithResp_code:resp.code OpenId:WXAppID Complete:^(id responseObject, NSError *error) {
        /**
         {
         "access_token" = "Hdd6geOB3ciupwKhWtmLgbNhuOzfEYMIM6ceckkL4JHC3SXhjDHhgirzysalAgs40oPaQXoO4boWrY-AwWgZ5y-MpVHThYsERZxmQjdprLA";
         "expires_in" = 7200;
         openid = "ogVstxLIFM0rGjBdRaFsO_QJGUEs";
         "refresh_token" = "nlCPsYI5ikKfYc85syfFmAZkYQU6EcieWJagcx7g-BrTEA0flTXIGvM2PbJpEYBCRt0fbH4qnnVAHRfYzmGY4MShRTK0LIIzjApSaYgytAc";
         scope = "snsapi_userinfo";
         unionid = "oFvPXwPQ9QwgeFDS-o3obMG24O00";
         }
         */
        if (responseObject && !error) {
            _open_id = responseObject[@"openid"];
            _access_token = responseObject[@"access_token"];
            _refresh_token = responseObject[@"refresh_token"];
            [self getWechatUserinfo];
            
            if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:loginSuccess:errorMsg:)]) {
                [self.callDelegate callType:NHApp_Wechat loginSuccess:YES errorMsg:nil];
            }
            
        }else{
            NHTipWithMessage(@"授权失败,未获取到token");
            if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:loginSuccess:errorMsg:)]) {
                [self.callDelegate callType:NHApp_Wechat loginSuccess:NO errorMsg:@"授权失败,未获取到token"];
            }
        }
    }];
}

/**
 *  完成分享操作(分享成功、分享失败)
 */
- (void)completeShare:(id)resp{
    if ([resp isKindOfClass:SendMessageToWXResp.class]) {
        SendMessageToWXResp *wxresp = (SendMessageToWXResp *)resp;
        BOOL result = wxresp.errCode;
        if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:shareSuccess:errorMsg:)]) {
            [self.callDelegate callType:NHApp_Wechat shareSuccess:!result errorMsg:wxresp.errStr];
        }
    }
}


/**
 * 获取用户信息
 */
- (void)getWechatUserinfo{
    __weak __typeof(self)weakself = self;
    [NHApiRequestHelper getWXUserinfoWithAccessToken:_access_token OpenId:_open_id Complete:^(id responseObject, NSError *error) {
        if (responseObject && !error) {
            weakself.wechatUserinfo = [[NHWechatUserinfo alloc] init];
            [weakself.wechatUserinfo setValuesForKeysWithDictionary:responseObject];
        }else{
            NHTipWithMessage([NSString stringWithFormat:@"获取用户信息失败:%@",error.localizedDescription]);
        }
        if (self.callDelegate && [self.callDelegate respondsToSelector:@selector(callType:userinfo:errorMsg:)]) {
            [self.callDelegate callType:NHApp_Wechat userinfo:weakself.wechatUserinfo errorMsg:error.localizedDescription];
        }
    }];
}


#pragma mark - Public Methods
+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [self requestWithText:text
                                     OrMediaMessage:nil
                                              bText:YES
                                            InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene {
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    
    WXMediaMessage *message = [self messageWithTitle:nil
                                         Description:nil
                                              Object:ext
                                          MessageExt:messageExt
                                       MessageAction:action
                                          ThumbImage:thumbImage
                                            MediaTag:tagName];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    
    return [WXApi sendReq:req];
}

+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [self messageWithTitle:title
                                         Description:description
                                              Object:ext
                                          MessageExt:nil
                                       MessageAction:nil
                                          ThumbImage:thumbImage
                                            MediaTag:tagName];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = musicURL;
    ext.musicDataUrl = dataURL;
    
    WXMediaMessage *message = [self messageWithTitle:title
                                         Description:description
                                              Object:ext
                                          MessageExt:nil
                                       MessageAction:nil
                                          ThumbImage:thumbImage
                                            MediaTag:nil];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    
    return [WXApi sendReq:req];
}

+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    ext.fileData = fileData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene {
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = info;
    ext.url = url;
    ext.fileData = data;
    
    WXMediaMessage *message = [self messageWithTitle:title
                                         Description:description
                                              Object:ext
                                          MessageExt:messageExt
                                       MessageAction:action
                                          ThumbImage:thumbImage
                                            MediaTag:nil];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    return [WXApi sendReq:req];
    
}

+ (BOOL)addCardsToCardPackage:(NSArray *)cardIds cardExts:(NSArray *)cardExts{
    NSMutableArray *cardItems = [NSMutableArray array];
    for (NSString *cardId in cardIds) {
        WXCardItem *item = [[WXCardItem alloc] init];
        item.cardId = cardId;
        item.appID = @"wxf8b4f85f3a794e77";
        [cardItems addObject:item];
    }
    
    for (NSInteger index = 0; index < cardItems.count; index++) {
        WXCardItem *item = cardItems[index];
        NSString *ext = cardExts[index];
        item.extMsg = ext;
    }
    
    AddCardToWXCardPackageReq *req = [[AddCardToWXCardPackageReq alloc] init];
    req.cardAry = cardItems;
    return [WXApi sendReq:req];
}

+ (BOOL)chooseCard:(NSString *)appid
          cardSign:(NSString *)cardSign
          nonceStr:(NSString *)nonceStr
          signType:(NSString *)signType
         timestamp:(UInt32)timestamp
{
    WXChooseCardReq *chooseCardReq = [[WXChooseCardReq alloc] init];
    chooseCardReq.appID = appid;
    chooseCardReq.cardSign = cardSign;
    chooseCardReq.nonceStr = nonceStr;
    chooseCardReq.signType = signType;
    chooseCardReq.timeStamp = timestamp;
    return [WXApi sendReq:chooseCardReq];
    
}


+ (BOOL)openProfileWithAppID:(NSString *)appID
                 Description:(NSString *)description
                    UserName:(NSString *)userName
                      ExtMsg:(NSString *)extMessage {
    [WXApi registerApp:appID];
    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
    req.profileType = WXBizProfileType_Device;
    req.username = userName;
    req.extMsg = extMessage;
    return [WXApi sendReq:req];
}

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg {
    [WXApi registerApp:appID];
    JumpToBizWebviewReq *req = [[JumpToBizWebviewReq alloc]init];
    req.tousrname = tousrname;
    req.extMsg = extMsg;
    req.webType = WXMPWebviewType_Ad;
    return [WXApi sendReq:req];
}

+ (BOOL)openUrl:(NSString *)url
{
    OpenWebviewReq *req = [[OpenWebviewReq alloc] init];
    req.url = url;
    return [WXApi sendReq:req];
}

+ (BOOL)openHBWithAppid:(NSString *)appid
                package:(NSString *)package
                   sign:(NSString *)sign;
{
    [WXApi registerApp:appid];
    HBReq *aHBReq = [[HBReq alloc] init];
    aHBReq.nonceStr = @"1474873519_wxsphb";
    aHBReq.timeStamp = 1474873519;
    aHBReq.package = package;
    aHBReq.sign = sign;
    return [WXApi sendReq:aHBReq];
}



+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    return message;
}

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

+ (GetMessageFromWXResp *)responseWithText:(NSString *)text
                            OrMediaMessage:(WXMediaMessage *)message
                                     bText:(BOOL)bText {
    GetMessageFromWXResp *resp = [[GetMessageFromWXResp alloc] init];
    resp.bText = bText;
    if (bText)
        resp.text = text;
    else
        resp.message = message;
    return resp;
}

@end

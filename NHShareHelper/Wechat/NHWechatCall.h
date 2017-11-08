//
//  NHWechatCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCall.h"
#import "WeChatSDK/WXApiObject.h"
#import "WeChatSDK/WXApi.h"
#import "WeChatSDK/WechatAuthSDK.h"

//微信分享结果
typedef NS_ENUM(NSInteger, NHWXAUTH_RESULT){
    
    NHWXAUTH_CODE_OK        = 0,  /**成功*/
    NHWXAUTH_CODE_CANCEL    = -2, /**用户取消*/
    NHWXAUTH_CODE_DENIED    = -4, /**用户拒绝授权*/
    NHWXAUTH_CODE_UNSUPPORT = -5  /**微信不支持*/
};

@interface NHWechatCall : NHCall<WXApiDelegate>
@property (nonatomic, strong) NHWechatUserinfo *wechatUserinfo;
@property (nonatomic, assign) id<NHCallProtocol> callDelegate;


+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene;

+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene;

/**
 *  文字、图片、链接分享
 *
 *  @param urlString   urlString
 *  @param tagName     tagName
 *  @param title       标题
 *  @param description 描述内容
 *  @param thumbImage  缩略图
 *  @param scene       分享场景
 */
+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene;

+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene;

+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene;

+ (BOOL)addCardsToCardPackage:(NSArray *)cardIds cardExts:(NSArray *)cardExts;

+ (BOOL)openProfileWithAppID:(NSString *)appID
                 Description:(NSString *)description
                    UserName:(NSString *)userName
                      ExtMsg:(NSString *)extMessage;

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg;

+ (BOOL)chooseCard:(NSString *)appid
          cardSign:(NSString *)cardSign
          nonceStr:(NSString *)nonceStr
          signType:(NSString *)signType
         timestamp:(UInt32)timestamp;

+ (BOOL)openUrl:(NSString *)url;

+ (BOOL)openHBWithAppid:(NSString *)appid
                package:(NSString *)package
                   sign:(NSString *)sign;

@end

//
//  NHWechatCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "NHUserinfo.h"


//微信分享结果
typedef NS_ENUM(NSInteger, NHWXAUTH_RESULT){
    
    NHWXAUTH_CODE_OK        = 0,  /**成功*/
    NHWXAUTH_CODE_CANCEL    = -2, /**用户取消*/
    NHWXAUTH_CODE_DENIED    = -4, /**用户拒绝授权*/
    NHWXAUTH_CODE_UNSUPPORT = -5  /**微信不支持*/
};

@protocol NHWechatCallDelegate <NSObject>
- (void)wechatRequestUserinfo:(NHWechatUserinfo *)userinfo error:(NSError *)error;
- (void)wechatLoginResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
- (void)wechatShareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;

@end

@interface NHWechatCall : NSObject<WXApiDelegate>
@property (nonatomic, assign) id<NHWechatCallDelegate> delegate;
@property (nonatomic, strong) NHWechatUserinfo *wechatUserinfo;

/**
 *  打开微信后的回调
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  微信注册
 *  @param appID appID
 */
- (BOOL)wechatRegistWithAppID:(NSString *)appID;

/**
 *  微信登录请求
 */
- (void)wechatLoginRequest;
- (void)wechatLoginRequestSetViewController:(UIViewController *)viewController;


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

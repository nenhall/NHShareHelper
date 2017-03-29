//
//  NHAlibabaCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/3/29.
//  Copyright © 2017年 NegHao. All rights reserved.
//

#import "NHCall.h"
#import "APOpenAPI.h"


typedef NS_ENUM(NSInteger, AlibabaShareScene){
    AlibabaShareFriend,
    AlibabaShareLifeCircle,
};

@interface NHAlibabaCall : NHCall
@property (nonatomic, assign) id<NHCallProtocol> callDelegate;
NSSingletonH(call);


/**
 *  纯文本消息
 */
+ (void)sendMessageText:(NSString *)text scene:(APScene)scene;


/**
 *  图片消息(image)
 */
+ (void)sendPhotoByUrlString:(NSString *)urlStr scene:(APScene)scene;


/**
 *  图片消息(data)
 */
+ (void)sendPhotoByData:(NSData *)data scene:(APScene)scene;

/**
 *  发送网页消息到支付宝(缩略图链接形式)
 *
 *  @param urlStr      分享链接
 *  @param title       分享标题
 *  @param description 简要说明
 *  @param thumbUrl    图片Url
 *  @param scene       分享场景
 */
+ (void)sendWebByUrlString:(NSString *)urlStr
                     title:(NSString *)title
               description:(NSString *)description
                  thumbUrl:(NSString *)thumbUrl
                     scene:(APScene)scene;

/**
 *  发送网页消息到支付宝(缩略图链接形式)
 *
 *  @param data        图片data
 *  @param urlStr      分享链接
 *  @param title       分享标题
 *  @param description 简要说明
 *  @param scene       分享场景
 */
+ (void)sendWebByData:(NSData *)data
            urlString:(NSString *)urlStr
                title:(NSString *)title
          description:(NSString *)description
                scene:(APScene)scene;
@end

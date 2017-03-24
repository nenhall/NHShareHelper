//
//  NHWeiBoCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "NHShareConfiguration.h"
#import "NHUserinfo.h"


@protocol NHWeiBoCallDelegate <NSObject>
- (void)weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo error:(NSError *)error;
- (void)weiBoLoginResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
- (void)weiBoShareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
@end
@interface NHWeiBoCall : NSObject
@property (nonatomic, assign)id<NHWeiBoCallDelegate> delegate;
NSSingletonH(NHWeiBoCall);

/**
 *  回调url
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  微博注册
 *  @param appID appID
 */
- (BOOL)weiboRegistWithAppID:(NSString *)appID;

/**
 *  微信登录请求
 */
- (void)weiboLoginRequest;


/**
 *  微博分享
 *
 *  @param compereName   分享标题
 *  @param thumbnailData 主题图片
 *  @param webpageUrl    网页链接
 */
+ (void)sendRequestWithCompereName:(NSString *)compereName
                     thumbnailData:(NSData *)thumbnailData
                        webpageUrl:(NSString *)webpageUrl;



@end

//
//  NHQQCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "NHUserinfo.h"


typedef NS_ENUM(NSInteger, NHQQShareType) {
    NHQQShare_Zone = 0x01,//空间
    NHQQShare_Forbid = 0x02,
    NHQQShare_Session = 0x04,//QQ好友
    NHQQShare_Favorites = 0x08,//收藏
    NHQQShare_Dataline = 0x10,//数据线
};


@protocol NHQQCallDelegate <NSObject>
- (void)QQRequestUserinfo:(NHQQUserinfo *)userinfo errorMsg:(NSString *)errorMsg;
- (void)QQLoginResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
- (void)QQShareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;

@end

@interface NHQQCall : NSObject<TencentSessionDelegate,QQApiInterfaceDelegate>
@property (nonatomic, assign) id<NHQQCallDelegate> delegate;
@property (nonatomic, strong) NHQQUserinfo *QQUserinfo;

/**
 *  回调url
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  qq注册
 *  @param appID appID
 */
- (TencentOAuth *)tencentQQRegistWithAppID:(NSString *)appID;

/**
 *  QQ登录请求
 */
- (void)tencentQQLoginRequest;

/**
 *  QQ分享、空间分享
 *
 *  @param compereName   分享标题
 *  @param urlStr        分享URL
 *  @param previewImgURL 预览封面Url
 *  @param shareType     分享类型
 */
+ (void)sendCompereName:(NSString *)compereName
                 urlStr:(NSString *)urlStr
            description:(NSString *)description
          previewImgURL:(NSString *)previewImgURL
              shareType:(NHQQShareType)shareType;

@end

//
//  NHQQCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCall.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenApi/QQApiInterface.h>
#import <TencentOpenApi/QQApiInterfaceObject.h>



typedef NS_ENUM(NSInteger, NHQQShareType) {
    NHQQShare_Zone = 0x01,//空间
    NHQQShare_Forbid = 0x02,
    NHQQShare_Session = 0x04,//QQ好友
    NHQQShare_Favorites = 0x08,//收藏
    NHQQShare_Dataline = 0x10,//数据线
};

@interface NHQQCall : NHCall<TencentSessionDelegate,QQApiInterfaceDelegate,
TencentApiInterfaceDelegate>

@property (nonatomic, strong) NHQQUserinfo *QQUserinfo;
@property (nonatomic, assign) id<NHCallProtocol> callDelegate;


/**
 *  QQ分享、空间分享
 *
 *  @param title         分享标题
 *  @param urlStr        分享URL
 *  @param previewImgURL 预览封面Url
 *  @param shareType     分享类型
 */
+ (void)sendTitle:(NSString *)title
           urlStr:(NSString *)urlStr
      description:(NSString *)description
    previewImgURL:(NSString *)previewImgURL
        shareType:(NHQQShareType)shareType;

@end

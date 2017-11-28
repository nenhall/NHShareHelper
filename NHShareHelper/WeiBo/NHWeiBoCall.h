//
//  NHWeiBoCall.h
//  NHShareHelperDemo
//
//  Created by neghao on 2017/2/15.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCall.h"

@interface NHWeiBoCall : NHCall
@property (nonatomic, assign) id<NHCallProtocol> callDelegate;

//NSSingletonH(WeiBoCall);

/**
 *  微博分享
 *
 *  @param title         分享标题
 *  @param thumbnailData 主题图片
 *  @param webpageUrl    网页链接
 */
+ (void)sendTitle:(NSString *)title
    thumbnailData:(NSData *)thumbnailData
       webpageUrl:(NSString *)webpageUrl;



@end

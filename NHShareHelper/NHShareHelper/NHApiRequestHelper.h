//
//  NHApiRequestHelper.h
//  NHShareHelper
//
//  Created by neghao on 2017/2/20.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^CompleteBlock)(id responseObject, NSError *error);



@interface NHApiRequestHelper : NSObject
@property (nonatomic, copy) CompleteBlock completeBlock;
/**
 *  获取token
 *
 *  @param resp_code  resp_code
 *  @param open_id      open_id
 */
+ (void)getWXTokenWithResp_code:(NSString *)resp_code OpenId:(NSString *)open_id Complete:(CompleteBlock)complete;


/**
 *  获取用户信息
 *
 *  @param access_token access_token
 *  @param open_id      open_id
 *  @param complete     complete 
 */
+ (void)getWXUserinfoWithAccessToken:(NSString *)access_token OpenId:(NSString *)open_id Complete:(CompleteBlock)complete;
@end

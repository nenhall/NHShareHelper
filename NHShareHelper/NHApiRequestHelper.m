//
//  NHApiRequestHelper.m
//  NHShareHelper
//
//  Created by neghao on 2017/2/20.
//  Copyright © 2017年 NegHao.Studio. All rights reserved.
//

#import "NHApiRequestHelper.h"
#import "NHShareConfiguration.h"

//获取用户个人信息（UnionID机制）
#define WXGetUserInfo       @"https://api.weixin.qq.com/sns/userinfo"

//通过code获取access_token
#define BKWXGetTokenUrl     @"https://api.weixin.qq.com/sns/oauth2/access_token"

//检验授权凭证（access_token）是否有效
#define BKWXGetAvailability @"https://api.weixin.qq.com/sns/auth"

//刷新access_token有效期
#define BKWXRefreshToken    @"https://api.weixin.qq.com/sns/oauth2/refresh_token"
//?appid=APPID&grant_type=refresh_token&refresh_token=REFRESH_TOKEN

@implementation NHApiRequestHelper

+ (void)getWXTokenWithResp_code:(NSString *)resp_code OpenId:(NSString *)open_id Complete:(CompleteBlock)complete{
    NSDictionary *URLParams = @{@"appid":open_id,
                                 @"secret":@"9fcb3ea4a0be054f924dd1ea506a0d0d",
                                 @"code":resp_code,
                                 @"grant_type":@"authorization_code"};
    
    [self sendRequestUrlString:BKWXGetTokenUrl URLParams:URLParams Complete:^(id responseObject, NSError *error) {
        if (complete) {
            complete(responseObject,error);
        }
    }];
}


+ (void)getWXUserinfoWithAccessToken:(NSString *)access_token OpenId:(NSString *)open_id Complete:(CompleteBlock)complete{
        NSDictionary *URLParams  = @{@"access_token":access_token,@"openid":open_id};
    [self sendRequestUrlString:WXGetUserInfo URLParams:URLParams Complete:^(id responseObject, NSError *error) {
        if (complete) {
            complete(responseObject,error);
        }
    }];
}

+ (void)sendRequestUrlString:(NSString *)urlString URLParams:(NSDictionary *)urlParams Complete:(CompleteBlock)complete{
    /* Configure session, choose between:
     * defaultSessionConfiguration
     * ephemeralSessionConfiguration
     * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    /* Create the Request:
     inke-near (GET http://120.55.238.158/api/live/near_flow_old)
     */
    
    NSURL* URL = [NSURL URLWithString:urlString];

    URL = NSURLByAppendingQueryParameters(URL, urlParams);
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
//    [request addValue:@"aliyungf_tc=AQAAAA+KPh9waAYAzxwOt9nnuZ6NRs1O" forHTTPHeaderField:@"Cookie"];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *responseObject;
        if (error == nil) {
         responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            // Success
            NHNSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            
        } else {
            // Failure
            NHNSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
        if (complete) {
            complete(responseObject,error);
        }
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}

/*
 * Utils: Add this section before your class implementation
 */

/**
 This creates a new query parameters string from the given NSDictionary. For
 example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
 string will be @"day=Tuesday&month=January".
 @param queryParameters The input dictionary.
 @return The created parameters string.
 */
static NSString* NSStringFromQueryParameters(NSDictionary* queryParameters)
{
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding],
                          [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

/**
 Creates a new URL by adding the given query parameters.
 @param URL The input URL.
 @param queryParameters The query parameter dictionary to add.
 @return A new NSURL.
 */
static NSURL* NSURLByAppendingQueryParameters(NSURL* URL, NSDictionary* queryParameters)
{
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [URL absoluteString],
                           NSStringFromQueryParameters(queryParameters)
                           ];
    return [NSURL URLWithString:URLString];
}






@end

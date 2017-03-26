//
//  NHShareCallToolProtocol.h
//  NHShareHelperDemo
//
//  Created by neghao on 3/26/17.
//  Copyright © 2017 NegHao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NHCall.h"


@protocol NHShareCallToolProtocol <NSObject>
- (void)nhcallType:(NHAppType)appType userinfo:(__kindof NHUserinfo *)userinfo errorMsg:(NSString *)errorMsg;
- (void)nhcallType:(NHAppType)appType loginSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;
- (void)nhcallType:(NHAppType)appType shareSuccess:(BOOL)success errorMsg:(NSString *)errorMsg;

@end

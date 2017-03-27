## QQ、微博、微信、Facebook、Google、支付宝、Twitter分享
<br/>

 ![Aaron Swartz](https://github.com/NegHao/NHShareHelper/blob/master/pic.png)
 
 <br/>
使用方法：
<br/>

#### 一、在需要使用分享、登录的头文件中
`#import "NHShareCallTool.h"`
<br/>
如你只需要QQ、微博分享、登录，那么把`NHShareHelper`文件夹下其它app的` .h .m `文件删除即可。
<br/>
#### 二、在AppDelegate.m文件中,重写如下方法：
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //注册app
    [NHShareCallTool registerAppSetAppConsts:@[NHQQ,NHWeiBo,NHWechat,NHFacebook]];
    
    //需要使用到facebook才需要调用
    [NHFacebook application:application
                didFinishLaunchingWithOptions:launchOptions
                enableUpdatesOnAccessTokenChange:YES];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [NHShareCallTool application:application
                                openURL:url
                      sourceApplication:sourceApplication
                             annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [NHShareCallTool application:application
                                openURL:url
                      sourceApplication:nil
                             annotation:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [NHShareCallTool application:application
                         openURL:url
               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return handled;
}
```

<br/>


#### 三、使用登陆或者分享的类，调用如下方法：

```
@interface ViewController ()<NHShareCallToolDelegate>

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NHShareCallTool sharedCallTool] addDelegate:self];
}
```

##### 使用方法:

```
//登录 eg：qq登录
[NHShareCallTool loginSetAppConst:NHQQ viewController:nil];

//QQ分享
[NHQQCall sendCompereName:shareTitle
                   urlStr:shareUrl
            previewImgURL:@"http://avatar.csdn.net/F/F/C/1_laencho.jpg"
                shareType:QQShare_Zone];
		    
//微信分享 
[NHWechatCall sendLinkURL:shareUrl
                 TagName:shareTitle
                   Title:shareTitle
             Description:shareTitle
              ThumbImage:[UIImage imageNamed:@"test"]
                 InScene:WXSceneSession];
   
//微博分享
NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"]];
[NHWeiBoCall sendRequestWithCompereName:shareTitle
                          thumbnailData:data
                             webpageUrl:shareUrl];
```

<br/>

##### 分享结果回调代理：
##### 登陆结果代理回调：

```Objective-C
@protocol NHShareCallToolDelegate <NSObject>
/**
 *  获取QQ用户信息结果
 */
- (void)nh_QQRequestUserinfo:(NHQQUserinfo *)userinfo error:(NSError *)error;

/**
 *  获取微信用户信息结果
 */
- (void)nh_wechatRequestUserinfo:(NHWechatUserinfo *)userinfo error:(NSError *)error;

/**
 *  获取微博用户信息结果
 */
- (void)nh_weiBoRequestUserinfo:(NHWeiBoUserinfo *)userinfo error:(NSError *)error;

/**
 *  登陆结果，调用此方法时还未请求到用户信息
    根据项目需要，如果你需要在登录后立即做些什么，请实现此代理方法
 *
 *  @param appType  登录类型
 *  @param success  是否成功
 *  @param errorMsg 错误信息
 */
- (void)nh_loginResultAppType:(NHAppType)appType Success:(BOOL)success errorMsg:(NSString *)errorMsg;

/**
 *  分享结果
 *
 *  @param success   是否成功
 *  @param errorMsg  错误信息
 *  @param shareType 分享类型
 */
- (void)nh_shareResultSuccess:(BOOL)success errorMsg:(NSString *)errorMsg shareType:(NHAppType)shareType;
@end
```

<br/>

#### 四、工程配置：
具体的的第三方SDK配置，请参照相应的官方文档；<br/>
这里说下工程配置：<br/>
1. 把如下的appID、appSecret设置成你自己的
![Aaron Swartz](https://github.com/NegHao/NHShareHelper/blob/master/appid.png)
2. URL Schemes配置，下面** 行中的key改成你自己的：
![Aaron Swartz](https://github.com/NegHao/NHShareHelper/blob/master/settiing.png)
3. info.plist配置：<br/>
info.plist文件右键 > open AS > source code，添加如下配置，注意：是在</plist>前面的</dict>前面添加如下

```
<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>alipay</string>
		<string>wechat</string>
		<string>weixin</string>
		<string>sinaweibohd</string>
		<string>sinaweibo</string>
		<string>sinaweibosso</string>
		<string>weibosdk</string>
		<string>weibosdk2.5</string>
		<string>weibosdk3.1</string>
		<string>mqq</string>
		<string>mqqapi</string>
		<string>mqqwpa</string>
		<string>mqqbrowser</string>
		<string>mttbrowser</string>
		<string>mqqOpensdkSSoLogin</string>
		<string>mqqopensdkapiV2</string>
		<string>mqqopensdkapiV3</string>
		<string>mqqopensdkapiV4</string>
		<string>wtloginmqq2</string>
		<string>mqzone</string>
		<string>mqzoneopensdk</string>
		<string>mqzoneopensdkapi</string>
		<string>mqzoneopensdkapi19</string>
		<string>mqzoneopensdkapiV2</string>
		<string>mqqapiwallet</string>
		<string>mqqopensdkfriend</string>
		<string>mqqopensdkdataline</string>
		<string>mqqgamebindinggroup</string>
		<string>mqqopensdkgrouptribeshare</string>
		<string>tencentapi.qq.reqContent</string>
		<string>tencentapi.qzone.reqContent</string>
		<string>fbapi</string>
		<string>fb-messenger-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
```

<br/>

```	
<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>alipay.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>alipayobjects.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSTemporaryExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>qq.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>sina.cn</key>
			<dict>
				<key>NSExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>sina.com.cn</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>sinaimg.cn</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>sinajs.cn</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>weibo.cn</key>
			<dict>
				<key>NSExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
			<key>weibo.com</key>
			<dict>
				<key>NSExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
				<false/>
			</dict>
		</dict>
	</dict>
```
<br/>
![Aaron Swartz](https://github.com/NegHao/NHShareHelper/blob/master/otherflags.png)

#### 五、第三方sdk下载地址：
因sdk包比较大，所以请自动去官网下载相应的sdk包，也更好保证是官网最新版sdk，本来想用cocoapod管理的，但有些公司的pod库更新得很慢，无法保证sdk的版本，所以还是手动下载吧！下载完成后拖入到`shareSDKS`文件夹下相应的文件夹内：
<br/>
qq: http://wiki.open.qq.com/wiki/mobile/SDK下载<br/>
wechat: https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419319164&token=&lang=zh_CN<br/>
weiBo: http://open.weibo.com/wiki/SDK<br/>
facebook: https://developers.facebook.com/docs/ios<br/>

![Aaron Swartz](https://github.com/NegHao/NHShareHelper/blob/master/SDK.png)

facebook的sdk包会有多个framework库，如果只是使用基础的登录分享功能的话，只需要拖入上图中的几库就可以了。




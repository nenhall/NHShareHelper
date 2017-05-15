## Alibaba的相关配置说明：
#### 登录相关：
流程简介：

1. 用户进入商家app；
2. 商家对应页面引导用户进行免登或者授权操作；
3. 商家通过支付宝客户端sdk唤起无线账户授权产品；
4. 支付宝sdk自动判断用户当前环境是否已经安装了支付宝app，如果有，唤起支付宝app内对应授权页面；如果用户未安装支付宝app，sdk为用户打开h5形式的授权页面；
5. 用户在支付宝授权页面进行信息授权；
6. 支付宝判断用户是否授权成功，如果成功则返回给商家对应授权用户的支付宝id和支付宝 authCode；如果用户授权失败，则本次服务结束；
7. 商家使用 authCode 来换取 token；
8. 商家如果仅使用支付宝id进行快速登录，则本次产品调用流程结束；商家如果需要更多授权支付宝用户的信息，则使用之前获取的token调用“支付宝用户信息查询接口”查询用户基本信息。
<br/>
在Build Phases选项卡的Link Binary With Libraries中，增加以下依赖：

![Aaron Swartz](https://github.com/NegHao/NHShareHelper/blob/master/help/alibabaframework.png)

<br/>
`TARGETS > Build Setting > Other Linker Flags 添加 -ObjC`
<br/>

1. 关于签名代码问题
NHShareHelper/NHShareHelper/Util及下面所有文件
NHShareHelper/NHShareHelper/openssl及下面所有文件
NHShareHelper/shareSDKs/AliSDK/AliPaySDK/libcrypto.a
NHShareHelper/shareSDKs/AliSDK/AliPaySDK/libssl.a
这些文件是为示例签名所在客户端本地使用。实际场景下请商户把私钥保存在服务端，在服务端进行支付请求参数签名。
<br/>
2. 点击项目名称，点击“Build Settings”选项卡，在搜索框中，以关键字“search”搜索，对“Header Search Paths”增加头文件路径：$(SRCROOT)/项目名称。如果头文件信息已增加，可不必再增加。
<br/>
3. 点击项目名称，点击“Info”选项卡，在“URL Types”选项中，点击“+”，在“URL Schemes”中输入“com.neghao.share”。“com.neghao.share”来自于文件“NHAlibabaCall.m”的NSString *appScheme = @“com.neghao.share”;（改在你自己的，两者保成一致，建议跟商户的app有一定的标示度，要做到和其他的商户app不重复，否则可能会导致支付宝返回的结果无法正确跳回商户app）。

#### 注意：SDK付款及登录有两种模式：如果外部存在支付宝钱包，则直接跳转到支付宝钱包付款；不存在的场景下，在SDK内部进行H5支付或登录。测试同学需要关注这两类测试场景。
官方文档：https://doc.open.alipay.com/docs/doc.htm?spm=a219a.7629140.0.0.a6mex3&treeId=218&articleId=105326&docType=1


#### 分享：

1. Bundle Identifier 需要去开发平台上设置成一致的；
2. 添加工程白名单：
`
<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>alipay</string>
		<string>alipayshare</string>
		<string>alipaytlshare</string>
	</array>
`
3. `TARGETS > Build Setting > Other Linker Flags 添加 -all_load`
4. 为URL Types 添加支付宝回调scheme:
`TARGETS > Info > URL types >添加 Identifier:alipayShare  URL Schemes:ap****`*代表你的appID

> ######注意： 
Identifier必须为 alipayShare；
URL Schemes 命名规则：'ap'+APPID


##使用支付宝的登录及支付，需要与支付宝签约，签约完成后会获得pid(即商户id，登录开发者网站上可以看到)；如果只是用分享则不需要进行签约，直接登录你的账户后添加相应的功能即可；若没有签约跳转到支付宝后会直接提示错误一个5位数错误码，无中文的错误信息。



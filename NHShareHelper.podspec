Pod::Spec.new do |s|
  s.name         = 'NHShareHelper'
  s.version      = '1.0.0'
  s.license      = 'LICENSE'
  s.homepage     = 'https://github.com/neghao/NHShareHelper'
  s.author       = { "neghao_pro" => "neghao@126.com" }
  s.summary      = 'iOS 分享工具类'

  s.platform     =  :ios, '7.0'
  s.source       = { :git => "https://github.com/neghao/NHShareHelper.git", :tag => "#{s.version}" }
  s.requires_arc = true
  s.default_subspec = 'WeiBo', 'QQ', 'Wechat', 'AliOpen', 'AliPay', 'Facebook'
  # s.pod_target_xcconfig = {'Enable Strict Checking of objc_msgSend Calls' => 'NO'}
  #EOS
  #s.prefix_header_contents = pch_AF

s.subspec 'Gener' do |ss|
    ss.source_files = 'NHShareHelper/Gener/*.{h,m}'
end

s.subspec 'WeiBo' do |wb|
# ss.dependency 'Weibo_SDK'
wb.dependency 'NHShareHelper/Gener'
wb.ios.source_files    = 'NHShareHelper/WeiBo/*.{h,m,md}', 'NHShareHelper/WeiBo/WeiboSDK/*.{h}'
wb.resource            = 'NHShareHelper/WeiBo/WeiboSDK/WeiboSDK.bundle'
wb.frameworks          = 'Photos', 'ImageIO', 'SystemConfiguration', 'CoreText', 'QuartzCore', 'Security', 'UIKit', 'Foundation', 'CoreGraphics','CoreTelephony'
wb.ios.libraries       = 'z', 'sqlite3'
wb.vendored_libraries  = 'NHShareHelper/WeiBo/WeiboSDK/libWeiboSDK.a'
wb.public_header_files = 'NHShareHelper/WeiBo/*.{h}'
end

s.subspec 'QQ' do |qq|
	qq.dependency 'NHShareHelper/Gener'
	# qq.requires_arc = false
	qq.ios.source_files    = 'NHShareHelper/QQ/*.{h,m,md}'
	qq.resource            = 'NHShareHelper/QQ/TencentOpenApi/TencentOpenApi_IOS_Bundle.bundle'
	qq.ios.frameworks      = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	qq.ios.libraries       = 'iconv','stdc++', 'z', 'sqlite3'
	qq.vendored_frameworks = 'NHShareHelper/QQ/TencentOpenApi/TencentOpenApi.framework'
	qq.public_header_files = 'NHShareHelper/QQ/*.{h}'
	#, 'NHShareHelper/QQ/TencentOpenApi/TencentOpenApi.framework/Headers/*.{h}'
end

s.subspec 'Wechat' do |wx|
	wx.dependency 'NHShareHelper/Gener'
	wx.ios.source_files    = 'NHShareHelper/Wechat/*.{h,m,md}', 'NHShareHelper/Wechat/WeChatSDK/*.{h,txt}'
	wx.ios.frameworks      = 'UIKit','CoreGraphics'
	wx.vendored_libraries  = 'NHShareHelper/Wechat/WeChatSDK/libWeChatSDK.a'
	wx.public_header_files = 'NHShareHelper/Wechat/*.{h}'
end

s.subspec 'AliOpen' do |alo|
	alo.ios.source_files    = 'NHShareHelper/AliOpen/*.{h,m}', 'NHShareHelper/AliOpen/**'
	alo.ios.frameworks      = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	alo.ios.libraries       = 'iconv','stdc++', 'z', 'sqlite3'
	alo.public_header_files = 'NHShareHelper/AliOpen/*.{h}'
end

s.subspec 'AliPay' do |alp|
	alp.ios.source_files    = 'NHShareHelper/AliPay/*.{h,m}', 'NHShareHelper/AliPay/**'
	alp.ios.frameworks      = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	alp.ios.libraries       = 'iconv','stdc++', 'z', 'sqlite3'
	alp.public_header_files = 'NHShareHelper/AliPay/*.{h}'
end

s.subspec 'Facebook' do |fb|
	  #fb.dependencies 'FBSDKCoreKit' 
	  #fb.dependencies 'FBSDKShareKit' 
	  #fb.dependencies 'FBSDKLoginKit'
	fb.ios.source_files    = 'NHShareHelper/Facebook/*.{h,m}', 'NHShareHelper/Facebook/**'
	fb.ios.frameworks      = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	fb.ios.libraries       = 'iconv','stdc++', 'z', 'sqlite3'
	fb.public_header_files = 'NHShareHelper/Facebook/*.{h}'
end


end

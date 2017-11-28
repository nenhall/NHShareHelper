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

s.subspec 'WeiBo' do |ss|
# ss.dependency 'Weibo_SDK'
ss.dependency 'NHShareHelper/Gener'
ss.ios.source_files   = 'NHShareHelper/WeiBo/*.{h,m,md}', 'NHShareHelper/WeiBo/WeiboSDK/*.{h}'
ss.resource       = 'NHShareHelper/WeiBo/WeiboSDK/WeiboSDK.bundle'
ss.frameworks     = 'Photos', 'ImageIO', 'SystemConfiguration', 'CoreText', 'QuartzCore', 'Security', 'UIKit', 'Foundation', 'CoreGraphics','CoreTelephony'
ss.ios.libraries  = 'z', 'sqlite3'
ss.vendored_libraries = 'NHShareHelper/WeiBo/WeiboSDK/libWeiboSDK.a'
ss.public_header_files = 'NHShareHelper/WeiBo/*.{h}'
end

s.subspec 'QQ' do |ss|
	ss.dependency 'NHShareHelper/Gener'
	ss.ios.source_files   = 'NHShareHelper/QQ/*.{h,m,md}'
	ss.resource       = 'NHShareHelper/QQ/TencentOpenApi/TencentOpenApi_IOS_Bundle.bundle'
	ss.ios.frameworks = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	ss.ios.libraries  = 'iconv','stdc++', 'z', 'sqlite3'
	ss.vendored_frameworks = 'NHShareHelper/QQ/TencentOpenApi/TencentOpenApi.framework'
	ss.public_header_files = 'NHShareHelper/QQ/*.{h}'
	#, 'NHShareHelper/QQ/TencentOpenApi/TencentOpenApi.framework/Headers/*.{h}'
end

s.subspec 'Wechat' do |ss|
	ss.dependency 'NHShareHelper/Gener'
	ss.ios.source_files   = 'NHShareHelper/Wechat/*.{h,m,md}', 'NHShareHelper/Wechat/WeChatSDK/*.{h,txt}'
	ss.ios.frameworks = 'UIKit','CoreGraphics'
	ss.vendored_libraries = 'NHShareHelper/Wechat/WeChatSDK/libWeChatSDK.a'
	ss.public_header_files = 'NHShareHelper/Wechat/*.{h}'
end

s.subspec 'AliOpen' do |ss|
	ss.ios.source_files   = 'NHShareHelper/AliOpen/*.{h,m}', 'NHShareHelper/AliOpen/**'
	ss.ios.frameworks = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	ss.ios.libraries  = 'iconv','stdc++', 'z', 'sqlite3'
	ss.public_header_files = 'NHShareHelper/AliOpen/*.{h}'
end

s.subspec 'AliPay' do |ss|
	ss.ios.source_files   = 'NHShareHelper/AliPay/*.{h,m}', 'NHShareHelper/AliPay/**'
	ss.ios.frameworks = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	ss.ios.libraries  = 'iconv','stdc++', 'z', 'sqlite3'
	ss.public_header_files = 'NHShareHelper/AliPay/*.{h}'
end

s.subspec 'Facebook' do |ss|
	ss.ios.source_files   = 'NHShareHelper/Facebook/*.{h,m}', 'NHShareHelper/Facebook/**'
	ss.ios.frameworks = 'Security', 'SystemConfiguration','CoreGraphics','CoreTelephony'
	ss.ios.libraries  = 'iconv','stdc++', 'z', 'sqlite3'
	ss.public_header_files = 'NHShareHelper/Facebook/*.{h}'
end

# Pod Dependencies
  #s.dependencies 'FBSDKCoreKit' 'FBSDKShareKit' 'FBSDKLoginKit'

end

Pod::Spec.new do |s|
  s.name         = 'NHShareHelper'
  s.version      = '1.0.0'
  s.license      = 'LICENSE'
  s.homepage     = 'https://github.com/neghao/NHShareHelper'
  s.author       = { "neghao_pro" => "neghao@126.com" }
  s.summary      = 'iOS 分享工具类'

  s.platform     =  :ios, '7.0'
  s.source       = { :git => "https://github.com/neghao/NHShareHelper.git", :tag => "#{s.version}" }
  s.source_files = 'NHShareHelper/**/*.{h,m}'
  s.frameworks   = 'UIKit', 'Foundation','Photos',
  					'CoreMotion','Security','SystemConfiguration',
  					'CoreGraphics','CoreTelephony','CFNetwork','QuartzCore','ImageIO','CoreText'
  					
  s.libraries    = 'z','iconv','stdc','sqlite3','sqlite3.0'
  s.requires_arc = true
  
# Pod Dependencies
  #s.dependencies 'FBSDKCoreKit' 'FBSDKShareKit' 'FBSDKLoginKit'

end

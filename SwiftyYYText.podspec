Pod::Spec.new do |s|
  s.name         = 'SwiftyYYText'
  s.summary      = 'Powerful text framework for iOS to display and edit rich text.'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'ZeroOnet' => 'zeroonetworkspace@gmail.com' }
  s.social_media_url = 'https://zeroonet.com'
  s.homepage     = 'https://github.com/ZeroOnet/SwiftyYYText'
  s.platform     = :ios, '11.0'
  s.ios.deployment_target = '11.0'
  s.source       = { :git => 'git@github.com:ZeroOnet/SwiftyYYText.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.source_files = 'SwiftyYYText/**/*.swift'

  s.frameworks = 'UIKit', 'CoreFoundation','CoreText', 'QuartzCore', 'Accelerate', 'MobileCoreServices'
end

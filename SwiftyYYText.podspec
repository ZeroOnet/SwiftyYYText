Pod::Spec.new do |s|
  s.name             = 'SwiftyYYText'
  s.version          = '0.1.0'
  s.summary          = '简单说明 SwiftyYYText 的用途.'

  s.homepage         = 'https://git.17bdc.com/ios/SwiftyYYText'
  s.author           = { 'Shanbay iOS' => 'ios@shanbay.com' }
  s.source           = { git: 'git@git.17bdc.com:ios/SwiftyYYText.git', tag: s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'SwiftyYYText/Classes/**/*.{swift}'
end

Pod::Spec.new do |spec|
  spec.name = 'GuillotineMenu-ObjC'
  spec.version = '0.3'

  spec.homepage = 'http://yalantis.com/blog/how-we-created-guillotine-menu-animation/'
  spec.summary = 'Custom menu transition from Navigation Bar'

  spec.author = 'taglia3'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.social_media_url = 'https://twitter.com/yalantis'

  spec.platform = :ios, '8.0'
  spec.ios.deployment_target = '8.0'

  spec.source = { :git => 'https://github.com/farshidce/GuillotineMenu-Yalantis-ObjC-Version.git', :tag => '0.3' }

  spec.requires_arc = true
  spec.frameworks = 'UIKit'
  spec.source_files = 'GuillotineMenu/*.{h,m}'
  spec.public_header_files = 'GuillotineMenu/*.h'
  spec.compiler_flags = '-Warc-retain-cycles'
end

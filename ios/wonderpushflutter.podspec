#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wonderpushflutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wonderpushflutter'
  s.version          = '0.0.1'
  s.summary          = 'WonderPush Flutter SDK'
  s.description      = <<-DESC
WonderPush Flutter SDK
                       DESC
  s.homepage         = 'https://www.wonderpush.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WonderPush' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'WonderPush', '~> 3.3.3'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end

#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wonderpush_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wonderpush_flutter'
  s.version          = '4.4.3'
  s.summary          = 'WonderPush Flutter SDK'
  s.description      = <<-DESC
WonderPush Flutter SDK
                       DESC
  s.homepage         = 'https://www.wonderpush.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WonderPush' => 'dev@wonderpush.com' }
  s.source           = { :path => '.' }
  s.source_files = 'wonderpush_flutter/Sources/wonderpush_flutter/**/*.{h,m}'
  s.public_header_files = 'wonderpush_flutter/Sources/wonderpush_flutter/include/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'WonderPush', '4.4.3'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end

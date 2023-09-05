#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wonderpush_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wonderpush_flutter'
  s.version          = '4.1.6'
  s.summary          = 'WonderPush Flutter SDK'
  s.description      = <<-DESC
WonderPush Flutter SDK
                       DESC
  s.homepage         = 'https://www.wonderpush.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'WonderPush' => 'dev@wonderpush.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'WonderPush', '4.1.6'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end

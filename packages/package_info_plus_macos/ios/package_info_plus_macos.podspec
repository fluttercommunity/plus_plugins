#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'package_info_plus_macos'
  s.version          = '0.0.1'
  s.summary          = 'No-op implementation of the macos package_info_plus plugin to avoid build issues on iOS'
  s.description      = <<-DESC
No-op implementation of the macos package_info_plus plugin to avoid build issues on iOS
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/package_info_plus/tree/master/package_info_plus/package_info_plus_macos'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Community' => 'authors@fluttercommunity.dev' }
  s.source           = { :http => 'https://github.com/fluttercommunity/package_info_plus/tree/master/package_info_plus/package_info_plus_macos' }
  s.documentation_url = 'https://pub.dev/packages/package_info_plus'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end

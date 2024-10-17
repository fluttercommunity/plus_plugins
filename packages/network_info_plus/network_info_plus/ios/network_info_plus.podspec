#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'network_info_plus'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Network Info'
  s.description      = <<-DESC
This plugin allows Flutter apps to discover network info and configure themselves accordingly.
Downloaded by pub (not CocoaPods).
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/plus_plugins'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Community Team' => 'authors@fluttercommunity.dev' }
  s.source           = { :http => 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/network_info_plus' }
  s.documentation_url = 'https://pub.dev/packages/network_info_plus'
  s.source_files = 'network_info_plus/Sources/network_info_plus/**/*.{h,m,c}'
  s.public_header_files = 'network_info_plus/Sources/network_info_plus/include/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.resource_bundles = {'network_info_plus_privacy' => ['network_info_plus/Sources/network_info_plus/PrivacyInfo.xcprivacy']}
end

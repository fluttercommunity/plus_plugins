#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'connectivity_plus'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Connectivity'
  s.description      = <<-DESC
This plugin allows Flutter apps to discover network connectivity and configure themselves accordingly.
Downloaded by pub (not CocoaPods).
                       DESC
  s.homepage         = 'https://plus.fluttercommunity.dev/'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Community Team' => 'authors@fluttercommunity.dev' }
  s.source           = { :http => 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/connectivity_plus' }
  s.documentation_url = 'https://pub.dev/packages/connectivity_plus'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'ReachabilitySwift'
  s.platform = :ios, '12.0'
  s.swift_version = '5.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end

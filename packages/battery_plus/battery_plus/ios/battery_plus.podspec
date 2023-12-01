#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'battery_plus'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for accessing information about the battery_plus.'
  s.description      = <<-DESC
A Flutter plugin to access various information about the battery of the device the app is running on.
Downloaded by pub (not CocoaPods).
                       DESC
  s.homepage         = 'https://plus.fluttercommunity.dev/'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Community Team' => 'authors@fluttercommunity.dev' }
  s.source           = { :http => 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/battery_plus' }
  s.documentation_url = 'https://pub.dev/packages/battery_plus'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end

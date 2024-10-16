#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint battery_plus_macos.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'battery_plus'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Battery Plus'
  s.description      = <<-DESC
A Flutter plugin for accessing information about the battery state(full, charging, discharging).
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/battery_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Community' => 'authors@fluttercommunity.dev' }
  s.source           = { :path => 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/battery_plus' }
  s.source_files     = 'battery_plus/Sources/battery_plus/**/*.swift'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
  s.resource_bundles = {'battery_plus_privacy' => ['battery_plus/Sources/battery_plus/PrivacyInfo.xcprivacy']}
end

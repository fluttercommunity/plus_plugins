#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'network_info_plus'
  s.version          = '0.0.1'
  s.summary          = 'No-op implementation of the macos network_info_plus to avoid build issues on macos'
  s.description      = <<-DESC
  No-op implementation of the network_info_plus plugin to avoid build issues on macos.
  https://github.com/flutter/flutter/issues/46618
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/plus_plugins'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'FlutterMacOS'

  s.platform = :osx
  s.osx.deployment_target = '10.14'
  s.resource_bundles = {'network_info_plus_privacy' => ['PrivacyInfo.xcprivacy']}
end


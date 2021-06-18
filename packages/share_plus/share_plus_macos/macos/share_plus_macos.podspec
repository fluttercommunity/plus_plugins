#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint share_plus_macos.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'share_plus_macos'
  s.version          = '0.0.1'
  s.summary          = 'Share Plus for macOS'
  s.description      = <<-DESC
A Flutter plugin for sharing text and files.
  DESC
  s.homepage         = 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus_macos'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Community' => 'authors@fluttercommunity.dev' }
  s.source           = { :path => 'https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus_macos' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end

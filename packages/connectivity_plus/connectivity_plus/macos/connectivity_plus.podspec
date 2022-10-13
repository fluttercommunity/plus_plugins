#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'connectivity_plus'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin for checking connectivity'
  s.description      = <<-DESC
  Desktop implementation of the connectivity plugin
                       DESC
  s.homepage         = 'https://plus.fluttercommunity.dev/'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Community Team' => 'authors@fluttercommunity.dev' }
  s.source           = { :http => 'https://github.com/fluttercommunity/plus_plugins' }
  s.documentation_url = 'https://pub.dev/packages/connectivity_plus'
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.dependency 'ReachabilitySwift'

  s.platform = :osx
  s.osx.deployment_target = '10.11'
end

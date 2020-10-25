#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'battery_plus'
  s.version          = '0.0.1'
  s.summary          = 'No-op implementation of the macos battery_plus to avoid build issues on macos'
  s.description      = <<-DESC
A Flutter plugin for accessing information about the battery state(full, charging, discharging).
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/plus_plugins/tree/master/packages/battery_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Community' => 'authors@fluttercommunity.dev' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.platform = :osx
  s.osx.deployment_target = '10.11'
end

Pod::Spec.new do |s|
  s.name             = 'package_info_plus'
  s.version          = '0.4.5'
  s.summary          = 'Flutter Package Info'
  s.description      = <<-DESC
This Flutter plugin provides an API for querying information about an application package.
Downloaded by pub (not CocoaPods).
                       DESC
  s.homepage         = 'https://github.com/fluttercommunity/package_info_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Flutter Community' => 'authors@fluttercommunity.dev' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }

end
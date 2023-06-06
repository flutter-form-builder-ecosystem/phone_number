#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint phone_number.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'phone_number'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for phone number validation'
  s.description      = <<-DESC
Flutter plugin for phone number validation
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.dependency 'PhoneNumberKit/PhoneNumberKitCore', '3.5.10'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

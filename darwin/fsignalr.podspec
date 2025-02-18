#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint fsignalr.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'fsignalr'
  s.version          = '0.0.1'
  s.summary          = 'Signalr plugin for Flutter on MacOS and iOS'
  s.description      = <<-DESC
Signalr plugin for Flutter on MacOS and iOS.
                       DESC
  s.homepage         = 'https://github.com/haidar0096/fsignalr'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Haidar Mehsen' => 'contact.hmehsen@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  # If your plugin requires a privacy manifest, for example if it collects user
  # data, update the PrivacyInfo.xcprivacy file to describe your plugin's
  # privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'fsignalr_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end

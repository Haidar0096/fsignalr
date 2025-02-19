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
  s.license          = { :type => 'BSD-3-Clause', :file => '../LICENSE' }
  s.author           = { 'Haidar Mehsen' => 'contact.hmehsen@gmail.com' }

  s.source = { :git => "https://github.com/Haidar0096/fsignalr.git", :tag => s.version.to_s }
  s.source_files = 'fsignalr/Sources/fsignalr/**/*.swift'
  s.resource_bundles = {'fsignalr_privacy' => ['fsignalr/Sources/fsignalr/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end

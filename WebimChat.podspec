#
# Be sure to run `pod lib lint WebimChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WebimChat'
  s.version          = '1.0.7'
  s.summary          = 'A short description of WebimChat.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitlab.tanuki.ru/tanuki-family-ios/webimchat.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Irina Romas' => 'romas_i@tanukitech.ru' }
  s.source           = { :git => 'https://github.com/IrinaRomasTnkTch/WebimChat', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'WebimChat/Classes/**/*'
  
   s.resource_bundles = {
       'WebimChat' => ['WebimChat/**/*.{png, xib, ttf}']
   }
   s.resources = "WebimChat/**/*.{ttf}", "WebimChat/Assets.xcassets"
   
   s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
   s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.frameworks = 'CoreGraphics'
  # s.dependency 'AFNetworking', '~> 2.3'
   s.dependency 'Nuke', '~> 8.0'
   s.dependency 'SnapKit', '~> 5.6.0'
   s.dependency 'WebimClientLibraryUpdated', '~> 3.38.6'
end

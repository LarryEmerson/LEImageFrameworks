#
# Be sure to run `pod lib lint LEImageFrameworks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'LEImageFrameworks'
s.version          = '0.1.9'
s.summary          = '图片缓存，滚动广告，单张图片选择，图片切割，朋友圈图片选择器封装，朋友圈图片查看器封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!


s.homepage         = 'https://github.com/LarryEmerson/LEImageFrameworks'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'LarryEmerson' => 'larryemerson@163.com' }
s.source           = { :git => 'https://github.com/LarryEmerson/LEImageFrameworks.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.ios.deployment_target = '7.0'

s.source_files = 'LEImageFrameworks/Classes/*.{h,m}'

# s.resource_bundles = {
#   'LEImageFrameworks' => ['LEImageFrameworks/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
s.dependency 'LEFrameworks'
s.dependency 'SDWebImage'
end

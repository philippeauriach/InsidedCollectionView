#
# Be sure to run `pod lib lint InsidedCollectionView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InsidedCollectionView'
  s.version          = '0.2.0'
  s.summary          = 'Allow inserting cells at specific interval in a collectionView or tableView without changing all indexes. Cool for inserting ads.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
You want to add some ads in your collection view without changing your model behind your data source ? Just specify the interval, and use the method provided by the manager to get your count and indexes. All the new indexes computation is made for you! It also handles inserting / deleting methods, without changing the intervals inserted items are at.
                       DESC

  s.homepage         = 'https://github.com/PhilippeAuriach/InsidedCollectionView'
  s.screenshots     = 'https://res.cloudinary.com/philippe-dev/image/upload/v1544115893/personal/pods/InsidedCollectionView/screenshot_1.png', 'https://res.cloudinary.com/philippe-dev/image/upload/v1544115893/personal/pods/InsidedCollectionView/screenshot_2.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PhilippeAuriach' => 'p.auriach@gmail.com' }
  s.source           = { :git => 'https://github.com/PhilippeAuriach/InsidedCollectionView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/philippeauriach'

  s.ios.deployment_target = '8.0'

  s.source_files = 'InsidedCollectionView/Classes/**/*'

  s.swift_version = '4.0'
  # s.resource_bundles = {
  #   'InsidedCollectionView' => ['InsidedCollectionView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Differ', '~> 1.3'
end

#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "ISO8601"
  s.version          = "0.1.3"
  s.summary          = "ISO8601 formatter"
  s.homepage         = "http://github.com/PAM-AS/"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  # s.license          = 'MIT'
  s.author           = { "han9kin" => "han9kin@gmail.com" }
  s.source           = { :git => "https://github.com/PAM-AS/iso8601.git", :tag => s.version.to_s }

  s.requires_arc = false

  s.source_files = 'ISO8601/NJISO8601Formatter.{h,m}', 'ISO8601/*.re'
end

#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "NJISO8601"
  s.version          = "0.2.0"
  s.summary          = "ISO8601 formatter"
  s.homepage         = "http://github.com/han9kin/"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'BSD'
  s.author           = { "han9kin" => "han9kin@gmail.com" }
  s.source           = { :git => "https://github.com/han9kin/iso8601.git", :tag => s.version.to_s }

  s.requires_arc = false

  s.source_files = 'ISO8601/NJISO8601Formatter.{h,m}', 'ISO8601/NJISO8601Parser.{h,m}'

  # s.prepare_command = <<-CMD
  #    ./Tools/re2c -cs -t "./ISO8601/NJISO8601Parser.h" -o "./ISO8601/NJISO8601Parser.m" ./ISO8601/NJISO8601Parser.re
  #  CMD
end

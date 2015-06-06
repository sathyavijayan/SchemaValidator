#
# Be sure to run `pod lib lint SchemaValidator.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SchemaValidator"
  s.version          = "0.1.0"
  s.summary          = "Schema based library to validate JSON like objects for Swift."
  s.description      = <<-DESC
                        You can use SchemaValidator to validate JSON like dictionary objects (for eg: anything that conforms to [NSObject:AnyObject] in Swift.
                        See README for more detail and usage.


                       DESC
  s.homepage         = "https://github.com/sathyavijayan/SchemaValidator"
  s.license          = 'MIT'
  s.author           = { "Sathyavijayan Vittal" => "sathyavijayan@gmail.com" }
  s.source           = { :git => "https://github.com/sathyavijayan/SchemaValidator.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'SchemaValidator' => ['Pod/Assets/*.png']
  }

end

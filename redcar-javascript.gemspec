
Gem::Specification.new do |s|
  s.name        = "redcar-javascript"
  s.version     = "0.1"
  s.platform    = "java"
  s.authors     = ["Daniel Lucraft", "Delisa Mason"]
  s.email       = ["dan@fluentradical.com"]
  s.homepage    = "http://github.com/redcar/redcar-javascript"
  s.summary     = "Redcar extensions for JavaScript development"
  s.description = ""
 
  s.files        = Dir.glob("{lib,features,vendor}/**/*") + %w(plugin.rb)
  s.executables  = []
  s.require_path = 'lib'
end
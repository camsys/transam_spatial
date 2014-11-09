$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "transam_spatial/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "transam_spatial"
  s.version     = TransamSpatial::VERSION
  s.authors     = ["Julian Ray"]
  s.email       = ["jray@camsys.com"]
  s.homepage    = "http://www.camsys.com"
  s.summary     = "Spatial Extensions for TransAM."
  s.description = "Spatial Extensions for TransAM."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'rails', '>=4.0.9'
  s.add_dependency "geocoder"
  s.add_dependency "georuby"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "cucumber-rails"
end
  
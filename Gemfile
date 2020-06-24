source "https://rubygems.org"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

gem 'active_record-acts_as', git: 'https://github.com/camsys/active_record-acts_as', branch: 'master' # use our fork

# To use debugger
# gem 'debugger'
gem 'transam_core', git: 'https://github.com/camsys/transam_core', branch: '2.11.0'

# needed for testing spatial mixins on transit models
gem 'transam_transit', git: 'https://github.com/camsys/transam_transit', branch: '2.11.0'

gem 'mysql2', "~> 0.5.1" # lock gem for dummy app
gem "capybara", '2.6.2' # lock gem for old capybara behavior on hidden element xpath
gem 'activerecord-mysql2rgeo-adapter', git: 'https://github.com/camsys/activerecord-mysql2rgeo-adapter', branch: 'master'
gem "rgeo"
gem 'rgeo-geojson'
gem 'rgeo-proj4'
gem 'figaro' # need to add an application.yml because need API keys to test geocode libraries

group :development, :test do
  gem 'byebug'
end

# Declare your gem's dependencies in transam_spatial.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

Dummy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Configure to use the rgeo geometry adapter
  config.transam_spatial_geometry_adapter = "rgeo"
  # setup the Rgeo projection to use. In this case Rgeo will use New York Long Island
  # State Plane (ft) as the projection system.
  config.rgeo_proj4       = '+proj=lcc +lat_1=41.03333333333333 +lat_2=40.66666666666666 +lat_0=40.16666666666666 +lon_0=-74 +x_0=300000.0000000001 +y_0=0 +ellps=GRS80 +datum=NAD83 +to_meter=0.3048006096012192 +no_defs'
  config.rgeo_proj4_srid  = 2263

  # Specify the test geocoding service
  Rails.application.config.geocoding_service  = "GoogleGeocodingService"

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true
  config.version = "TEST"
  config.max_upload_file_size = 4          # maximum file size able to be uploaded
  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_assets  = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.

  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr
  ENV["SYSTEM_SEND_FROM_ADDRESS"] = "donotreply@camsys-apps.com"
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end

# desc "Explaining what the task does"
# task :transam_spatial do
#   # Task goes here
# end
namespace :transam_spatial do
  desc "Prepare the dummy app for rspec and capybara"
  task :prepare_rspec => ["app:test:set_test_env", :environment] do
    %w(db:drop db:create db:schema:load db:migrate db:seed).each do |cmd|
      puts "Running #{cmd} in Spatial"
      Rake::Task[cmd].invoke
    end
  end

  desc "Test"
  task :update_geometry_view => :environment do
    view_sql = <<-SQL
      CREATE OR REPLACE VIEW geometry_transam_assets_view AS
      SELECT transam_assets.id, ST_X(geometry) as longitude, ST_Y(geometry) as latitude
      FROM transam_assets
    SQL

    ApplicationRecord.connection.execute view_sql
  end
end

namespace :test do
  desc "Custom dependency to set test environment"
  task :set_test_env do # Note that we don't load the :environment task dependency
    Rails.env = "test"
  end
end

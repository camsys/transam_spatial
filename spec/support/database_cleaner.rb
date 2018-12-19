RSpec.configure do |config|

  DatabaseCleaner.strategy = :truncation, {:only => %w[facilities transam_assets transit_assets infrastructures assets asset_events asset_groups asset_groups_assets messages notices policies policy_asset_type_rules policy_asset_subtype_rules organizations users users_organizations map_overlay_service_types map_overlay_services]}
  config.before(:suite) do
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end

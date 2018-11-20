FactoryBot.define do

  factory :fta_buses_class, :class => :fta_asset_class do
    association :fta_asset_category, :factory => :fta_revenue_vehicles_category
    name { 'Buses (Rubber Tire Vehicles)' }
    class_name { 'TransitAsset' }
    active { true }
  end

end
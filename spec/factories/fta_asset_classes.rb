FactoryBot.define do

  factory :fta_transit_assets_class, :class => :fta_asset_class do
    association :fta_asset_category, :factory => :fta_transit_assets_category
    name { 'Test Transit Assets' }
    class_name { 'TransitAsset' }
    active { true }
  end

  factory :fta_facilities_class, :class => :fta_asset_class do
    association :fta_asset_category, :factory => :fta_transit_assets_category
    name { 'Test Facilities' }
    class_name { 'Facility' }
    active { true }
  end

end
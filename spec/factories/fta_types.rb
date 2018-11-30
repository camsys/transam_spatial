FactoryBot.define do

  factory :fta_transit_type, :class => :fta_vehicle_type do
    association :fta_asset_class, :factory => :fta_transit_assets_class
    name { 'Vehicle' }
    code { 'VEH' }
    description { 'A generalized vehicle FTA type.' }
    active { true }
  end

  factory :fta_facility_type, :class => :fta_facility_type do
    association :fta_asset_class, :factory => :fta_facilities_class
    name { 'Test Facility' }
    description { 'Test Facility.' }
    active { true }
  end

end
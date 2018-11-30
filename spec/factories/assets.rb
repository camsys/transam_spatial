# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do

  sequence :asset_tag do |n|
    "ABS_TAG#{n}"
  end

  trait :basic_asset_attributes do
    association :organization, :factory => :organization
    asset_tag
    purchase_date { 1.year.ago }
    in_service_date { 1.year.ago }
    manufacture_year "2000"
  end

  factory :buslike_asset, :class => :asset do # An untyped asset which looks like a bus
    basic_asset_attributes
    association :asset_type
    association :asset_subtype
    purchase_cost { 2000.0 }
    expected_useful_life { 120 }
    reported_condition_rating { 2.0 }
    #replacement_value 100
    estimated_replacement_cost { 100 }
    fta_funding_type_id { 1 }
    created_by_id { 1 }
  end
  
  factory :basic_transam_asset, :class => :transam_asset do # An untyped transam asset
    asset_subtype
    organization
    asset_tag
    purchase_cost { 2000.0 }
    purchased_new { false }
    purchase_date { 1.year.ago }
    in_service_date { 1.year.ago }
    manufacturer
    manufacturer_model
  end

  factory :basic_transit_asset, :class => :transit_asset do # An untyped transit asset
    association :fta_asset_category, :factory => :fta_transit_assets_category

    trait :fta_facility do #fta asset class and type assignment for facilities
      association :fta_asset_class, :factory => :fta_facilities_class
      association :fta_type, :factory => :fta_facility_type
    end
    
    trait :fta_vehicle do #fta asset class and type assignment for vehicles
      association :fta_asset_class, :factory => :fta_transit_assets_class
      association :fta_type, :factory => :fta_transit_type
    end
  end

end

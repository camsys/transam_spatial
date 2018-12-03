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

  trait :transam_vehicle do
    association :asset_subtype, :factory => :vehicle_subtype
  end

  trait :transam_facility do
    association :asset_subtype, :factory => :facility_subtype
  end

  trait :fta_facility do #fta asset class and type assignment for facilities
    association :fta_asset_class, :factory => :fta_facilities_class
    association :fta_type, :factory => :fta_facility_type
  end

  trait :fta_vehicle do #fta asset class and type assignment for vehicles
    association :fta_asset_class, :factory => :fta_transit_assets_class
    association :fta_type, :factory => :fta_transit_type
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
    organization
    asset_tag
    purchase_cost { 2000.0 }
    purchase_date { 1.year.ago }
    purchased_new { false }
    in_service_date { 1.year.ago }
    after(:build) do |asset|
      parent_policy = Policy.where('parent_id IS NULL').count > 0 ? Policy.where('parent_id IS NULL').first : create(:parent_policy)
      create(:policy, organization: asset.organization, parent: parent_policy)
    end

    trait :transam_vehicle do
      association :asset_subtype, :vehicle_subtype
    end

    trait :transam_facility do
      association :asset_subtype, :facility_subtype
    end
  end

  factory :transit_vehicle, :class => :transit_asset do # An untyped transit asset which looks like a vehicle
    association :fta_asset_category, :factory => :fta_transit_assets_category
    fta_vehicle
  end
  
  factory :transit_facility, :class => :transit_asset do #An untyped transit asset which looks like a facility
    association :fta_asset_category, :factory => :fta_transit_assets_category
    fta_facility
  end

  factory :facility do
    association :transam_asset, factory: [:basic_transam_asset, :transam_facility]
    manufacture_year { 1.year.ago }
    facility_name { 'Test Facility' }
    address1 { '101 Station Landing' }
    address2 { 'Suite 410' }
    city { 'Medford' }
    state { 'MA' }
    zip { '02155' }
    country { 'USA' }
    esl_category_id { 10 }
    facility_size { 10000 }
    facility_size_unit { 'square foot' }
  end
end

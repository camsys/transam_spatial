# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do

  sequence :asset_tag do |n|
    "ABS_TAG#{n}"
  end

  trait :basic_asset_attributes do
    asset_tag
    purchase_cost { 2000.0 }
    purchase_date { 1.year.ago }
    in_service_date { 1.year.ago }
    purchased_new { false }
  end

  trait :transam_support_vehicle do
    basic_asset_attributes
    asset_subtype_id { 35 }
  end

  trait :transam_facility do
    basic_asset_attributes
    asset_subtype_id { 24 }
  end

  trait :transam_infrastructure do
    basic_asset_attributes
    asset_subtype_id { 61 }
  end

  trait :transit_service_vehicle do
    transam_support_vehicle
    after :initialize do |vehicle|
      vehicle.serial_number = "ABC123"
    end
    fta_asset_category_id { 2 }
    fta_asset_class_id { 5 }
    fta_type_id { 1 }
    fta_type_type { "FtaSupportVehicleType" }
  end

  trait :transit_facility do
    transam_facility
    fta_asset_category_id { 3 }
    fta_asset_class_id { 7 }
    fta_type_id { 11 }
    fta_type_type { "FtaFacilityType" }
  end

  trait :transit_infrastructure do
    transam_infrastructure
    fta_asset_category_id { 4 }
    fta_asset_class_id { 11 }
    fta_type_id { 1 }
    fta_type_type { "FtaGuidewayType" }
  end

  factory :service_vehicle do
    transit_service_vehicle
    manufacture_year { 1.year.ago }
    serial_number { 'ABC123' }
    manufacturer_id { 1 }
    manufacturer_model_id { 1 }
    fuel_type_id { 18 }
    vehicle_length { 10 }
    vehicle_length_unit { 'feet' }
    seating_capacity { 5 }
    ada_accessible { true }
  end

  factory :facility do
    transit_facility
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
    section_of_larger_facility { false }
  end

  factory :infrastructure do
    transit_infrastructure
    description { "Test infrastructure" }
    infrastructure_segment_unit_type_id { 2 }
    infrastructure_segment_type_id { 6 }
    infrastructure_division
    infrastructure_subdivision
  end
end

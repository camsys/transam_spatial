# Read about factories at https://github.com/thoughtbot/factory_bot

FactoryBot.define do

  sequence :asset_tag do |n|
    "ABS_TAG#{n}"
  end

  trait :basic_asset_attributes do
    asset_tag
    organization_id { 1 }
    purchase_cost { 2000.0 }
    purchase_date { 1.year.ago }
    in_service_date { 1.year.ago }
    purchased_new { false }
    before(:create) do
      parent_policy = create(:parent_policy)
      create(:policy, organization: parent_policy.organization, parent: parent_policy)
    end
  end
  
  trait :transam_facility do
    basic_asset_attributes
    asset_subtype_id { 24 }
  end
  
  trait :transit_facility do
    transam_facility
    fta_asset_category_id { 3 }
    fta_asset_class_id { 7 }
    fta_type_id { 11 }
    fta_type_type { "FtaFacilityType" }
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
end

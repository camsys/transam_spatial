FactoryBot.define do

  factory :facility do
    association :transit_asset, factory: [:basic_transit_asset, :fta_facility]
    manufacture_year { 2018 }
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
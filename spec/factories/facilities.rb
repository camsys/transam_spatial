FactoryBot.define do

  factory :facility do
    manufacture_year { 2018 }
    facility_name { 'Test Facility' }
    address1 { '101 Station Landing' }
    address2 { 'Suite 410' }
    city { 'Medford' }
    state { 'MA' }
    zip { '02155' }
    country { 'USA' }
    facility_size { 10000 }
    facility_size_unit { 'square foot' }
    association :transit_asset, factory: :buslike_transit_asset
  end
end
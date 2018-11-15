FactoryBot.define do

  factory :fta_bus_type, :class => :fta_vehicle_type do
    association :fta_asset_class, :factory => :fta_buses_class
    name { 'Bus' }
    code { 'BU' }
    description { 'Bus.' }
    active { true }
  end

end
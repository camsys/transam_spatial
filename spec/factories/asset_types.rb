FactoryBot.define do

  factory :vehicle_type, :class => :asset_type do
    name { "Vehicle" }
    class_name { "Vehicle" } # For core, no concrete classes exist
    display_icon_name { "display icon" }
    map_icon_name { "map icon" }
    description { "Vehicle." }
    active { true }
  end

  factory :facility_type, :class => :asset_type do
    name { "Facility" }
    class_name { "Facility" } # For core, no concrete classes exist
    display_icon_name { "display icon" }
    map_icon_name { "map icon" }
    description { "Facility." }
    active { true }
  end
end

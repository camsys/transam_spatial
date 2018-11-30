FactoryBot.define do

  factory :asset_type do
    name { "Test Asset Type" }
    class_name { "TestAssetType" } # For core, no concrete classes exist
    display_icon_name { "display icon" }
    map_icon_name { "map icon" }
    description { "An generalized asset type." }
    active { true }
  end
end

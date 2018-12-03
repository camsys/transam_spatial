FactoryBot.define do

  factory :asset_subtype do
    name { "Asset Subtype" }
    description { "A generalized asset subtype." }
    active { true }
    
    trait :vehicle_subtype do
      association :asset_type, factory: :vehicle_type
    end

    trait :facility_subtype do
      association :asset_type, factory: :facility_type
    end
  end
end

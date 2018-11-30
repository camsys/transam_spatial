FactoryBot.define do

  factory :asset_subtype do
    asset_type
    name { "Test Asset Subtype" }
    description { "A generalized asset subtype." }
    active { true }
  end

end

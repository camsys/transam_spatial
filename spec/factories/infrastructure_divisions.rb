FactoryBot.define do

  factory :infrastructure_division do
    name { "Test Division" }
    organization_id { 1 }
    active { true }
  end
end
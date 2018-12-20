FactoryBot.define do

  factory :infrastructure_subdivision do
    name { "Test Subdivision" }
    organization_id { 1 }
    active { true }
  end
end
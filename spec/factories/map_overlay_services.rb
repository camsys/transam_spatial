FactoryBot.define do
  factory :map_overlay_service do
    name { "Test Name" }
    association :organization
    association :map_overlay_service_type
    sequence :url do |n|
      "http://#{n}"
    end
  end
end

FactoryGirl.define do
  factory :map_overlay_service_type do
    name "Test Name"
    sequence :code do |n|
      "CODE#{n}"
    end
  end
end

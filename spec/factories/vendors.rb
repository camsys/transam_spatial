FactoryBot.define do

  factory :vendor do
    name { 'Test Vendor' }
    association :organization, :factory => :organization
  end

end
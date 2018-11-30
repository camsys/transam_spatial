FactoryBot.define do

  factory :manufacturer do
    filter { 'asset' }
    name { 'transam asset' }
    code { 'TAA' }
    active { true }
  end

end

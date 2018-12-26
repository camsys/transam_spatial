FactoryBot.define do

  trait :basic_policy_attributes do
    association :organization
    interest_rate { "0.05" }
    service_life_calculation_type_id { 1 }
    cost_calculation_type_id { 1 }
    condition_estimation_type_id { 1 }
    condition_threshold { 2.5 }
    name 'TestPolicy'
    description 'Test Policy'
    year Date.today.year
    current true
    active true
  end

  factory :policy do
    basic_policy_attributes
  end

  factory :parent_policy, :class => :policy do
    basic_policy_attributes

    transient do
      has_fuel_type false
    end

    transient do
      subtype 0
    end

    trait :fuel_type do
      has_fuel_type true
    end

    after(:create) do |policy, evaluator|
      AssetType.all.each do |type|
        create(:policy_asset_type_rule, policy: policy, asset_type: type)
      end
      create(:policy_asset_subtype_rule, (:fuel_type if evaluator.has_fuel_type), policy: policy, asset_subtype_id: evaluator.subtype)
    end
  end
end
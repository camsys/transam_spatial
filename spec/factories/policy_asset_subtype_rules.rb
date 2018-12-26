FactoryBot.define do

  factory :policy_asset_subtype_rule do
    min_service_life_months { 144 }
    min_service_life_miles { 500000 }
    replacement_cost { 2000 }
    cost_fy_year { Date.today.month > 6 ? Date.today.year - 1 : Date.today.year - 2 }
    replace_with_new { true }
    replace_with_leased { false }
    purchase_replacement_code { 'XX.XX.XX' }
    rehabilitation_code { 'XX.XX.XX' }
    default_rule { true }

    trait :fuel_type do
      fuel_type_id { 18 }
    end
  end

end

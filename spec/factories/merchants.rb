FactoryBot.define do
  factory :merchant do
    name { Faker::App.name }
  end

  factory :item do
    name { Faker::Games::Zelda.item }
    description { Faker::Lorem.sentence }
    unit_price { Faker::Number.number(digits: 4) }
    association :merchant
  end
end

def merchant_with_items(items_count: 5)
  FactoryBot.create(:merchant) do |merchant|
    FactoryBot.create_list(:item, items_count, merchant: merchant)
  end
end

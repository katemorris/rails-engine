FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity { rand(1..20) }
    unit_price { Faker::Commerce.price }
  end
end

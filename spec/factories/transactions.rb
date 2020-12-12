FactoryBot.define do
  factory :transaction do
    invoice_id { Faker::Book.title }
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiration_date { Faker::Business.credit_card_expiry_date }
    result { ['success', 'failed', 'refunded'].sample }
  end
end

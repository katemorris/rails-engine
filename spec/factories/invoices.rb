FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { ['packaged', 'returned', 'shipped'].sample }
  end
end

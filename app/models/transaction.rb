class Transaction < ApplicationRecord
  belongs_to :invoice

  validates :credit_card_number, presence: true
  validates :credit_card_expiration_date, presence: true
  validates :result, presence: true, acceptance: { accept: ['success', 'failed', 'refunded'] }

  scope :successful, -> { where("result = ?", "success") }
end

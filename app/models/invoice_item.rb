class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :quantity, presence: true
end

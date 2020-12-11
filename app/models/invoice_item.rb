class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates :invoice_id, presence: true
  validates :item_id, presence: true
  validates :quantity, presence: true
end

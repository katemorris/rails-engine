class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  validates :status, presence: true, acceptance: { accept: ['pending', 'packaged', 'returned', 'shipped'] }

  def self.remove_no_items
    Invoice.left_joins(:invoice_items)
    .where(invoice_items: {invoice_id: nil})
    .find_each do |invoice|
      invoice.destroy
    end
  end
end

class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  validates :name, presence: true

  def self.most_revenue(quantity)
    invoices = Invoice.joins(:transactions)
    .left_joins(:invoice_items)
    .select(:merchant_id, 'SUM(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .where('transactions.result = ? AND invoices.status = ?', "success", "shipped")
    .order('revenue')
    .group(:merchant_id)
    .limit(quantity)

    invoices.map do |invoice|
      Merchant.find(invoice.merchant_id)
    end
  end

  def self.most_items(quantity)

  end
end

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
    .order('revenue desc')
    .group(:merchant_id)
    .limit(quantity)

    find_merchants(invoices)
  end

  def self.most_items(quantity)
    invoices = Invoice.joins(:transactions)
    .left_joins(:invoice_items)
    .select(:merchant_id, 'SUM(invoice_items.quantity) as sold_items')
    .where('transactions.result = ? AND invoices.status = ?', "success", "shipped")
    .order('sold_items desc')
    .group(:merchant_id)
    .limit(quantity)

    find_merchants(invoices)
  end

  def self.find_merchants(data)
    data.map do |d|
      Merchant.find(d.merchant_id)
    end
  end
  #
  # def self.total_revenue(start_date, end
  #
  # end
end

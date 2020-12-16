class Merchant < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices

  validates :name, presence: true

  def self.most_revenue(quantity)

    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.unit_price * invoice_items.quantity) as revenue')
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .order('revenue desc')
    .group(:id)
    .limit(quantity)
  end

  def self.most_items(quantity)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, SUM(invoice_items.quantity) as sold_items')
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .order('sold_items desc')
    .group(:id)
    .limit(quantity)
  end

  def self.total_revenue(start_date, end_date)
    Merchant.joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .merge(Invoice.shipped)
    .where('DATE(invoices.updated_at) BETWEEN ? AND ?', start_date, end_date)
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end

end

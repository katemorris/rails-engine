class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.search(params)
    items = []
    params.each do |param, value|
      if param == 'created_at' || param == 'updated_at'
        items << Item.where("DATE(#{param}) = ?", "%#{value}%") if Item.has_attribute?(param)
      else
        items << Item.where("LOWER(#{param}) LIKE ?", "%#{value}%") if Item.has_attribute?(param)
      end
    end
    items.flatten
  end
end

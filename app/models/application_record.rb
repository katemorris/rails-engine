class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search(params, quantity = nil)
    items = []
    params.each do |param, value|
      if param == 'created_at' || param == 'updated_at'
        items << self.where("DATE(#{param}) = ?", "%#{value}%").limit(quantity) if self.has_attribute?(param)
      else
        items << self.where("LOWER(#{param}) LIKE ?", "%#{value.downcase}%").limit(quantity) if self.has_attribute?(param)
      end
    end
    items.flatten
  end
end

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of :unit_price }
  end

  describe 'class methods' do
    it '#search()' do
      fluffy = create(:item, description: 'Fluffy Bunny')
      mad = create(:item, description: 'Mad Bunny')
      create_list(:item, 3)
      params = {
        "description" => "bun",
        "controller" => "api/v1/items/search",
        "action" => "show"
      }
      expected = [fluffy, mad]
      expect(Item.search(params)).to eq(expected)
    end
  end
end

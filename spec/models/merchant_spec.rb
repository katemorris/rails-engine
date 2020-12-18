require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many :items }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'class methods' do
    before :each do
      #merchants
      @merchants = create_list(:merchant, 2)
      #items
      merchant1_item1 = create(:item, merchant: @merchants[1])
      merchant1_item2 = create(:item, merchant: @merchants[1])
      merchant0_item = create(:item, merchant: @merchants[0])
      #invoices
      merchant1_shipped = create(:invoice, merchant: @merchants[1], status: 'shipped')
      merchant1_returned = create(:invoice, merchant: @merchants[1], status: 'returned')
      merchant0_returned = create(:invoice, merchant: @merchants[0], status: 'returned')
      @merchant0_shipped = create(:invoice, merchant: @merchants[0], status: 'shipped')
      #invoiceitems
      create_list(:invoice_item, 10, invoice: merchant1_shipped, unit_price: 12, quantity: 1,item: merchant1_item1)
      create_list(:invoice_item, 1, invoice: merchant1_returned, unit_price: 10, quantity: 1,item: merchant1_item1)
      create_list(:invoice_item, 1, invoice: merchant0_returned, unit_price: 10, quantity: 1,item: merchant0_item)
      create_list(:invoice_item, 4, invoice: @merchant0_shipped, unit_price: 5, quantity: 1,item: merchant0_item)
      #transactions
      create(:transaction, invoice: merchant1_shipped, result: 'success')
      create(:transaction, invoice: merchant1_returned, result: 'refunded')
      create(:transaction, invoice: merchant0_returned, result: 'refunded')
      create(:transaction, invoice: @merchant0_shipped, result: 'success')
    end

    it '.most_revenue()' do
      expect(Merchant.most_revenue(1)).to eq([@merchants[1]])
    end

    it '.most_items()' do
      expect(Merchant.most_items(1)).to eq([@merchants[1]])
    end

    it '.total_revenue()' do
      start_date = Date.today - 30
      end_date = Date.today + 30
      expect(Merchant.total_revenue(start_date, end_date)).to eq(140)
    end
  end

  describe 'instance methods' do
    it '#revenue' do
      merchant = create(:merchant)
      items = create_list(:item, 3, merchant: merchant)
      invoice1 = create(:invoice, merchant: merchant, status: 'shipped')
      invoice2 = create(:invoice, merchant: merchant, status: 'returned')
      invoice3 = create(:invoice, merchant: merchant, status: 'shipped')
      #invoice_items
      create_list(:invoice_item, 3, invoice: invoice1, unit_price: 12, quantity: 2,item: items[0])
      create_list(:invoice_item, 1, invoice: invoice2, unit_price: 10, quantity: 1,item: items[1])
      create_list(:invoice_item, 1, invoice: invoice3, unit_price: 10, quantity: 1,item: items[2])
      #transactions
      create(:transaction, invoice: invoice1, result: 'success')
      create(:transaction, invoice: invoice2, result: 'refunded')
      create(:transaction, invoice: invoice3, result: 'refunded')

      expect(merchant.revenue).to eq(72.0)
    end
  end
end

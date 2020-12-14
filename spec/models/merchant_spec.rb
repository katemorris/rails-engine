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
      #invoices
      merchant1_shipped = create(:invoice, merchant: @merchants[1], status: 'shipped')
      merchant1_returned = create(:invoice, merchant: @merchants[1], status: 'returned')
      merchant0_returned = create(:invoice, merchant: @merchants[0], status: 'returned')
      merchant0_shipped = create(:invoice, merchant: @merchants[0], status: 'shipped')
      #invoiceitems
      create_list(:invoice_item, 3, invoice: merchant1_shipped)
      create_list(:invoice_item, 2, invoice: merchant1_returned)
      create_list(:invoice_item, 4, invoice: merchant0_returned)
      create_list(:invoice_item, 1, invoice: merchant0_shipped)
      #transactions
      create(:transaction, invoice: merchant1_shipped, result: 'success')
      create(:transaction, invoice: merchant1_returned, result: 'refunded')
      create(:transaction, invoice: merchant0_returned, result: 'refunded')
      create(:transaction, invoice: merchant0_shipped, result: 'success')
    end

    it '.most_revenue' do
      expect(Merchant.most_revenue(1)).to eq([@merchants[0]])
    end
  end
end

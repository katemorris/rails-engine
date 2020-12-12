require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many :transactions }
  end

  describe 'validations' do
    it { should validate_presence_of :status }
  end

  describe 'class methods' do
    it '#remove_no_items' do
      item = create(:item)
      id = item.id
      test_invoice = create(:invoice)
      test_id = test_invoice.id
      create(:invoice_item, invoice: test_invoice, item: item)
      other_invoice = create(:invoice)
      create(:invoice_item, invoice: other_invoice)


      item.destroy
      expect(test_invoice).to be_a(Invoice)
      expect(test_invoice.items.count).to eq(0)

      Invoice.remove_no_items

      expect{Invoice.find(test_id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect(Invoice.find(other_invoice.id)).to eq(other_invoice)
    end
  end
end

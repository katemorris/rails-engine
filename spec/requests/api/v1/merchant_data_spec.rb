require 'rails_helper'

describe 'Merchant API', type: :request do
  it 'returns merchants with the most revenue' do
    #merchants
    merchants = create_list(:merchant, 2)
    #invoices
    merchant1_shipped = create(:invoice, merchant: merchants[1], status: 'shipped')
    merchant1_returned = create(:invoice, merchant: merchants[1], status: 'returned')
    merchant0_returned = create(:invoice, merchant: merchants[0], status: 'returned')
    merchant0_shipped = create(:invoice, merchant: merchants[0], status: 'shipped')
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

    get '/api/v1/merchants/most_revenue?quantity=2'

    expect(response).to be_successful
    require "pry"; binding.pry
    merchants = JSON.parse(response.body, symbolize_names: true)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
end

require 'rails_helper'
require 'date'

describe 'Merchant API', type: :request do
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
    merchant0_shipped = create(:invoice, merchant: @merchants[0], status: 'shipped')
    #invoiceitems
    create_list(:invoice_item, 10, invoice: merchant1_shipped, unit_price: 12, quantity: 1,item: merchant1_item1)
    create_list(:invoice_item, 1, invoice: merchant1_returned, unit_price: 10, quantity: 1,item: merchant1_item1)
    create_list(:invoice_item, 1, invoice: merchant0_returned, unit_price: 10, quantity: 1,item: merchant0_item)
    create_list(:invoice_item, 4, invoice: merchant0_shipped, unit_price: 5, quantity: 1,item: merchant0_item)
    #transactions
    create(:transaction, invoice: merchant1_shipped, result: 'success')
    create(:transaction, invoice: merchant1_returned, result: 'refunded')
    create(:transaction, invoice: merchant0_returned, result: 'refunded')
    create(:transaction, invoice: merchant0_shipped, result: 'success')
  end

  it 'returns merchants with the most revenue' do
    get api_v1_merchants_most_revenue_path(:quantity => 2)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    expect(merchants[:data].first[:id]).to eq(@merchants[1].id.to_s)
    expect(merchants[:data].last[:id]).to eq(@merchants[0].id.to_s)
  end

  it 'returns no merchants if the quantity is zero' do
    get api_v1_merchants_most_revenue_path(:quantity => 0)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data]).to eq([])
  end

  it 'returns all merchants if the quantity is too large' do
    get api_v1_merchants_most_revenue_path(:quantity => 3)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)
  end

  it 'returns merchants with the most items sold' do
    get api_v1_merchants_most_items_path(:quantity => 2)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    expect(merchants[:data].first[:id]).to eq(@merchants[1].id.to_s)
  end

  it 'returns no merchants in most items query if the quantity is zero' do
    get api_v1_merchants_most_items_path(:quantity => 0)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data]).to eq([])
  end

  it 'returns all merchants in most items query if the quantity is too large' do
    get api_v1_merchants_most_items_path(:quantity => 3)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(2)
  end

  it 'returns total revenue for all merchants in a date range' do
    get api_v1_revenue_path(:start => Date.today - 30, :end => Date.today + 30)

    expect(response).to be_successful
    revenue = JSON.parse(response.body, symbolize_names: true)

    expect(revenue[:data][:attributes][:revenue].to_f.round(2)).to eq(140.0)
  end

  it 'returns zero if nothing exists in the date range' do
    get api_v1_revenue_path(:start => Date.today - 100, :end => Date.today - 90)

    expect(response).to be_successful
    revenue = JSON.parse(response.body, symbolize_names: true)

    expect(revenue[:data][:attributes][:revenue].to_f.round(2)).to eq(0.0)
  end

  it 'returns zero if the date ranges are reversed' do
    get api_v1_revenue_path(:start => Date.today + 30, :end => Date.today - 30)

    expect(response).to be_successful
    revenue = JSON.parse(response.body, symbolize_names: true)

    expect(revenue[:data][:attributes][:revenue].to_f.round(2)).to eq(0.0)
  end

  it 'returns total revenue for a single merchant' do
    get api_v1_merchant_revenue_path(@merchants[1].id)

    expect(response).to be_successful
    revenue = JSON.parse(response.body, symbolize_names: true)

    expect(revenue[:data][:attributes][:revenue].to_f.round(2)).to eq(120.0)
  end

  it 'returns 404 if the merchant does not exist' do
    get api_v1_merchant_revenue_path(1)

    expect(response.status).to eq(404)
  end
end

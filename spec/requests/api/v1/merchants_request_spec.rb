require 'rails_helper'

describe 'Merchant API', type: :request do
  it 'sends all merchant data' do
    n_merchants = create_list(:merchant, 3)

    get api_v1_merchants_path

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end

    expect(merchants.first[:id].to_i).to eq(n_merchants.first.id)
  end

  it "sends a merchant's info" do
    core_merchant = create(:merchant)

    get api_v1_merchant_path(core_merchant.id)

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq(core_merchant.name)
  end

  it 'creates a merchant' do
    merchant_params = {
      name: 'Starbucks'
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v1_merchants_path, headers: headers, params: JSON.generate(merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])
  end

  it 'updates a merchant info' do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = {name: 'ColdBrewz'}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch api_v1_merchant_path(id), headers: headers, params: JSON.generate(merchant_params)
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it 'deletes a merchant' do
    merchant = create(:merchant)

    expect{ delete api_v1_merchant_path(merchant.id) }.to change(Merchant, :count).by(-1)

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns the items for a merchant' do
    merchant = create(:merchant)
    m_items = create_list(:item, 5, merchant_id: merchant.id)

    get api_v1_merchant_items_path(merchant.id)

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end

    expect(items.first[:attributes][:unit_price]).to eq(m_items.first.unit_price)
  end
end

require 'rails_helper'

describe 'Items API', type: :request do
  it 'sends all items data' do
    made_items = create_list(:item, 3)

    get api_v1_items_path

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    items[:data].each do |item|
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

    expect(items[:data].first[:attributes][:name]).to eq(made_items.first.name)
    expect(items[:data].second[:attributes][:description]).to eq(made_items.second.description)

  end

  it 'sends an item data' do
    core_item = create(:item)

    get api_v1_item_path(core_item.id)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:name]).to eq(core_item.name)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
    expect(item[:attributes][:unit_price]).to eq(core_item.unit_price)

    expect(item[:attributes]).to have_key(:merchant_id)
    expect(item[:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'does not send an item if it does not exist' do
    get api_v1_item_path(58938)
    expect(response.status).to eq(404)
  end

  it 'creates an item' do
    merchant = create(:merchant)
    item_params = {
      name: 'CyberPunk 2077 T-Shirt',
      description: 'Amazingly soft shirt with the CyberPunk logo',
      unit_price: 27.99,
      merchant_id: merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'cannot create an item without necessary data' do
    merchant = create(:merchant)
    item_params = {
      name: 'CyberPunk 2077 T-Shirt',
      unit_price: 27.99,
      merchant_id: merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

    expect(response.status).to eq(422)
    expect(Item.find_by(name: item_params[:name])).to eq(nil)
  end

  it 'cannot create an item if the unit price is not a number' do
    merchant = create(:merchant)
    item_params = {
      name: 'CyberPunk 2077 T-Shirt',
      description: 'Amazingly soft shirt with the CyberPunk logo',
      unit_price: 'none',
      merchant_id: merchant.id
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    post api_v1_items_path, headers: headers, params: JSON.generate(item_params)

    expect(response.status).to eq(422)
    expect(Item.find_by(name: item_params[:name])).to eq(nil)
  end

  it 'updates an item info' do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = {name: 'Carrier Pidgeon'}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch api_v1_item_path(id), headers: headers, params: JSON.generate(item_params)
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(item_params[:name])
  end

  it 'cannot update an item with blank content' do
    item = create(:item)
    id = item.id
    previous_name = Item.last.name
    item_params = {name: ''}
    headers = {"CONTENT_TYPE" => "application/json"}

    patch api_v1_item_path(id), headers: headers, params: JSON.generate(item_params)

    expect(response.status).to eq(422)
    expect(item.name).to eq(previous_name)
  end

  it 'deletes an item' do
    item = create(:item)

    expect{ delete api_v1_item_path(item.id) }.to change(Item, :count).by(-1)

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns the merchant for an item' do
    item = create(:item)

    get api_v1_item_merchants_path(item.id)

    expect(response).to be_successful
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)
    expect(merchant[:id].to_i).to eq(item.merchant.id)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'cannot return the merchant if the item doesn not exist' do
    get api_v1_item_merchants_path(1)

    expect(response.status).to eq(404)
  end
end

require 'rails_helper'
require 'date'

describe 'Items Search API', type: :request do
  it 'finds one item using one input' do
    core_item = create(:item, name: 'Fluffy Bunny')
    create_list(:item, 3)
    attribute = :name
    query = 'bunny'

    get api_v1_items_find_path(attribute.to_sym => query)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

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

  it 'finds one item partial search in another field' do
    core_item = create(:item, description: 'Fluffy Bunny')
    create_list(:item, 3)
    attribute = :description
    query = 'bun'

    get api_v1_items_find_path(attribute.to_sym => query)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(core_item.id.to_s)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq(core_item[:name])
  end

  it 'finds one item by created date' do
    core_item = create(:item, created_at: DateTime.now - (2/24.0))

    create_list(:item, 3)
    attribute = :created_at
    query = core_item.created_at

    get api_v1_items_find_path(attribute.to_sym => query)

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(core_item.id.to_s)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to eq(core_item[:name])
  end

  it 'sends all items data for partial match' do
    item_1 = create(:item, name: 'Fluffy Bunny')
    create(:item, name: 'Fat Bunny')
    create(:item, name: 'Peanut Bunner')
    nope = create(:item, name: 'Superman')

    attribute = :name
    query = 'bun'

    get api_v1_items_find_all_path(attribute.to_sym => query)

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items.count).to eq(3)

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

    expect(items.first[:id].to_i).to eq(item_1.id)
    expect(items.include?(nope)).to eq(false)
  end
end

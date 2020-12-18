require 'rails_helper'
require 'date'

describe 'Merchant Search API', type: :request do
  before :each do
    @bunny = create(:merchant, name: 'Bunny Hill', created_at: DateTime.now - (2/24.0))
    create_list(:merchant, 3)
  end
  it 'finds one merchant using one input' do
    expect(Merchant.all.count).to eq(4)

    attribute = :name
    query = 'bunny'

    get api_v1_merchants_find_path(attribute.to_sym => query)

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_an(String)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to be_a(String)
    expect(merchant[:attributes][:name]).to eq(@bunny.name)
  end

  it 'finds one merchant partial search' do
    expect(Merchant.all.count).to eq(4)

    attribute = :name
    query = 'bun'

    get api_v1_merchants_find_path(attribute.to_sym => query)

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(@bunny.id.to_s)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(@bunny.name)
  end

  it 'finds one merchant by created date' do
    attribute = :created_at
    query = @bunny.created_at

    get api_v1_merchants_find_path(attribute.to_sym => query)

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(@bunny.id.to_s)

    expect(merchant[:attributes]).to have_key(:name)
    expect(merchant[:attributes][:name]).to eq(@bunny.name)
  end

  it 'sends all merchant data for partial match' do
    create(:merchant, name: 'Fluffy Bunny')
    create(:merchant, name: 'Fat Bunny')
    create(:merchant, name: 'Peanut Bunner')
    create(:merchant, name: 'Superman')

    attribute = :name
    query = 'bun'

    get api_v1_merchants_find_all_path(attribute.to_sym => query)

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(4)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
end

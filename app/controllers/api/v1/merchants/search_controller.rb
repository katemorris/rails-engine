class Api::V1::Merchants::SearchController < ApplicationController
  def index
    items = Merchant.search(params)
    render json: MerchantSerializer.new(items)
  end

  def show
    item = Merchant.search(params)
    render json: MerchantSerializer.new(item.first)
  end
end

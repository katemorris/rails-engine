class Api::V1::Items::SearchController < ApplicationController
  def index
    items = Item.search(params)
    render json: ItemSerializer.new(items)
  end

  def show
    item = Item.search(params, 1)
    render json: ItemSerializer.new(item.first)
  end
end

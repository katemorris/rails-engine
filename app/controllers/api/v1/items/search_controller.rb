class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.search(params)
    render json: ItemSerializer.new(item.first)
  end
end

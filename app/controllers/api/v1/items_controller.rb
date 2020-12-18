class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item)
  end

  def update
    if check_blank_params(params)
      render json: { error: 'data cannot be blank' }, status: :unprocessable_entity
    else
      item = Item.update(params[:id], item_params)
      render json: ItemSerializer.new(item)
    end
  end

  def destroy
    Item.destroy(params[:id])
    Invoice.remove_no_items
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end

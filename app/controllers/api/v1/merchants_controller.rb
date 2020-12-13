class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(
      Merchant.find(params[:id])
    )
  end

  def items
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end

  def create
    merchant = Merchant.create!(name: params[:name])
    render json: MerchantSerializer.new(merchant)
  end

  def update
    merchant = Merchant.update(params[:id], name: params[:name])
    render json: MerchantSerializer.new(merchant)
  end

  def destroy
    Merchant.destroy(params[:id])
  end

end

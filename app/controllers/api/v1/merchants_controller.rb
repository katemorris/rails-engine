class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(
      Merchant.find(params[:id])
    )
  end

  def create
    render json: MerchantSerializer.new(
      Merchant.create!(name: params[:merchant][:name])
    )
  end

  def update
    render json: MerchantSerializer.new(
      Merchant.update(params[:id], name: params[:merchant][:name])
    )
  end

  def destroy
    render json: MerchantSerializer.new(
      Merchant.destroy(params[:id])
    )
  end

end

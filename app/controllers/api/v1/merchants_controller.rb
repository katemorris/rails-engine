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
    merchant = Merchant.create!(name: params[:name])
    render json: MerchantSerializer.new(merchant)
  end

  def update
    if check_blank_params(params)
      render json: { error: 'data cannot be blank' }, status: :unprocessable_entity
    else
      merchant = Merchant.update(params[:id], name: params[:name])
      render json: MerchantSerializer.new(merchant)
    end
  end

  def destroy
    Merchant.destroy(params[:id])
  end

end

class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end

  def create
    render json: Merchant.create!(name: params[:merchant][:name])
  end

  def update
    render json: Merchant.update(params[:id], name: params[:merchant][:name])
  end

  def destroy
    render json: Merchant.destroy(params[:id])
  end

end

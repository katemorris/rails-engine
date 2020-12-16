class Api::V1::RevenueController < ApplicationController
  def index
    data = Merchant.total_revenue(params[:start], params[:end])
    render json: RevenueSerializer.revenue(data)
  end

  def show
    merchant = Merchant.find(params[:merchant_id])
    data = merchant.revenue
    render json: RevenueSerializer.revenue(data)
  end
end

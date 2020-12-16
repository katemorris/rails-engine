class Api::V1::RevenueController < ApplicationController
  def index
    data = Merchant.total_revenue(params[:start], params[:end])
    render json: RevenueSerializer.revenue(data)
  end
end

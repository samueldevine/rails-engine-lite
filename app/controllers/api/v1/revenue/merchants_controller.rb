class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    render json: MerchantNameRevenueSerializer.new(Merchant.top_merchants_by_revenue(params[:quantity]))
  end
end

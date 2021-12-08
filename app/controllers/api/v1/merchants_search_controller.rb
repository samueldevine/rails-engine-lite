class Api::V1::MerchantsSearchController < ApplicationController
  def show
    result = Merchant.find_one(params[:name])

    render json: MerchantSerializer.new(result)
  end
end

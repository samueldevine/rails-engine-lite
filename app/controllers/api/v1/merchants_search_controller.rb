class Api::V1::MerchantsSearchController < ApplicationController
  def show
    result = Merchant.find_one(params[:name])

    if result != nil
      render json: MerchantSerializer.new(result)
    else
      render json: MerchantSerializer.not_found
    end
  end
end

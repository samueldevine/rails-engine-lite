class Api::V1::MerchantsSearchController < ApplicationController
  def show
    if !params[:name]
      render json: { errors: { details: 'No params given' } }, status: 400
    elsif params[:name] == ''
      render json: { errors: { details: 'Search params cannot be empty' } }, status: 400
    else
      result = Merchant.find_one(params[:name])

      if !result.nil?
        render json: MerchantSerializer.new(result)
      else
        render json: MerchantSerializer.not_found
      end
    end
  end
end

class Api::V1::MerchantsBiController < ApplicationController
  def most_items
    render json: ItemsSoldSerializer.new(Merchant.most_items(params[:quantity]))
  end
end

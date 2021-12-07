class Api::V1::MerchantsController < ApplicationController
  def index
    render json: { "data" => Merchant.all }
  end

  def show
    render json: Merchant.find(params[:id])
  end
end

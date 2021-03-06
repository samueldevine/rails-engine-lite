class Api::V1::ItemsSearchController < ApplicationController
  def index
    if !params[:name] && !params[:min_price] && !params[:max_price]
      render json: ItemSerializer.no_params, status: 400
    elsif params[:name] && (params[:min_price] || params[:max_price])
      render json: ItemSerializer.name_and_price_params, status: 400
    elsif params[:name] == '' || params[:min_price] == '' || params[:max_price] == ''
      render json: ItemSerializer.empty_params, status: 400
    elsif params[:name]
      result = Item.find_all_by_name(params[:name])
      render json: ItemSerializer.new(result)
    elsif params[:min_price] && params[:max_price]
      result = Item.find_all_price_between(params[:min_price], params[:max_price])
      render json: ItemSerializer.new(result)
    elsif params[:min_price]
      result = Item.find_all_price_above(params[:min_price])
      render json: ItemSerializer.new(result)
    elsif params[:max_price]
      result = Item.find_all_price_below(params[:max_price])
      render json: ItemSerializer.new(result)
    end
  end
end

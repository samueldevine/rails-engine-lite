class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: 201 if item.save
  end

  def update
    item = Item.find(params[:id])
    if Merchant.exists?(item_params[:merchant_id]) || !item_params[:merchant_id]
      item.update(item_params)
      render json: ItemSerializer.new(item)
    else
      render json: { errors: { details: 'Merchant ID does not exist'}}, status: 400
    end
  end

  def destroy
    item = Item.find(params[:id])
    Item.destroy(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end

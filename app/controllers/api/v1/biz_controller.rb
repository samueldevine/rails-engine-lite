class Api::V1::BizController < ApplicationController
  def top_merchants
    render json: MerchantNameRevenueSerializer.new(Merchant.top_merchants_by_revenue(params[:quantity]))
  end

  def most_items
    render json: ItemsSoldSerializer.new(Merchant.most_items(params[:quantity]))
  end

  def total_revenue
    if params.key?(:start) && params.key?(:end)
      render json: TotalRevenueSerializer.new(Invoice.total_revenue(params[:start], params[:end]))
    else
      render json: {error: {details: 'Missing start and/or end date for range'}}, status: 400
    end
  end

  def single_merchant
    render json: TotalRevenueSerializer.new(Merchant.revenue(params[:id]))
  end
end

class MerchantDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end
end
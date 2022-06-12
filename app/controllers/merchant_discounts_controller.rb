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

  def update
    discount = Discount.find(params[:id])
    discount.update(discount_params)
    redirect_to "/merchants/#{discount.merchant.id}/discounts/#{params[:id]}"
  end

  private
    def discount_params
      params.require(:discount).permit(:percentage, :quantity)
    end
end
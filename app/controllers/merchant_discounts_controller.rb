class MerchantDiscountsController < ApplicationController
  before_action :get_upcoming_holidays, only: [:index]
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

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchants/#{discount.merchant.id}/discounts"
  end

  private
    def discount_params
      params.require(:discount).permit(:percentage, :quantity)
    end

    def get_upcoming_holidays
      @holidays = HolidaySearch.holiday_information
    end
end
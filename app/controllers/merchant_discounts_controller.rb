class MerchantDiscountsController < ApplicationController
  def index
    @discounts = Discount.all
  end
end
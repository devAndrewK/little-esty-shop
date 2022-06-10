require 'rails_helper'

RSpec.describe 'merchants discounts index', type: :feature do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "Toys Rn't Us")

    @merch_2.discounts.create!(percentage: 15, quantity: 20)
    @merch_2.discounts.create!(percentage: 20, quantity: 25)
    @merch_2.discounts.create!(percentage: 25, quantity: 30)


end

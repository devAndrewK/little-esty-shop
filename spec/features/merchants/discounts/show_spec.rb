require 'rails_helper'

RSpec.describe 'merchants discounts show', type: :feature do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "Toys Rn't Us")

    @discount1 = @merch_2.discounts.create!(percentage: 15, quantity: 20)
    @discount2 = @merch_2.discounts.create!(percentage: 20, quantity: 25)
    @discount3 = @merch_2.discounts.create!(percentage: 25, quantity: 30)

  end

  it 'lists discount attributes' do
    visit "/merchants/#{@merch_2.id}/discounts/#{@discount1.id}"
      expect(page).to have_content("Percentage Off: 15%")
      expect(page).to have_content("Quantity Needed: 20")
      expect(page).to_not have_content("Quantity Needed: 25")
      expect(page).to_not have_content("Quantity Needed: 30")
      expect(page).to_not have_content("Percentage Off: 20%")
      expect(page).to_not have_content("Percentage Off: 25%")
  end
end

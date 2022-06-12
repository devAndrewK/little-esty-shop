require 'rails_helper'

RSpec.describe 'merchants discounts edit', type: :feature do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "Toys Rn't Us")

    @discount1 = @merch_2.discounts.create!(percentage: 15, quantity: 20)
    @discount2 = @merch_2.discounts.create!(percentage: 20, quantity: 25)
    @discount3 = @merch_2.discounts.create!(percentage: 25, quantity: 30)

  end

  it 'has pre-filled form fields to edit' do
    visit "/discounts/#{@discount1.id}/edit"
    expect(page).to have_field('Percentage', with: 15)
    expect(page).to have_field('Quantity', with: 20)
  end

    it 'can fill in fields and submit form' do
    visit "/discounts/#{@discount1.id}/edit"
    fill_in 'Percentage', with: 40
    fill_in 'Quantity', with: 100
    click_button "Update"
    expect(current_path).to eq("/merchants/#{@merch_2.id}/discounts/#{@discount1.id}")
    expect(page).to have_content("Percentage Off: 40%")
    expect(page).to have_content("Quantity Needed: 100")
  end
end

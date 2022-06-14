require 'rails_helper'

RSpec.describe 'merchants discounts index', type: :feature do
  before(:each) do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")
    @merch_2 = Merchant.create!(name: "Toys Rn't Us")

    @discount1 = @merch_2.discounts.create!(percentage: 15, quantity: 20)
    @discount2 = @merch_2.discounts.create!(percentage: 20, quantity: 25)
    @discount3 = @merch_2.discounts.create!(percentage: 25, quantity: 30)

  end

  it 'lists discounts' do
    visit "/merchants/#{@merch_2.id}/discounts"
    within "#discount-#{@discount1.id}" do
      expect(page).to have_content("Get 15% off when you buy 20 units.")
      expect(page).to_not have_content("Get 20% off when you buy 25 units.")
      expect(page).to_not have_content("Get 25% off when you buy 30 units.")
      expect(page).to have_link("View")
    end
    within "#discount-#{@discount2.id}" do
      expect(page).to_not have_content("Get 15% off when you buy 20 units.")
      expect(page).to have_content("Get 20% off when you buy 25 units.")
      expect(page).to_not have_content("Get 25% off when you buy 30 units.")
      expect(page).to have_link("View")
    end
    within "#discount-#{@discount3.id}" do
      expect(page).to_not have_content("Get 15% off when you buy 20 units.")
      expect(page).to_not have_content("Get 20% off when you buy 25 units.")
      expect(page).to have_content("Get 25% off when you buy 30 units.")
      expect(page).to have_link("View")
    end
  end

  it "links to discount show page" do
      visit "/merchants/#{@merch_2.id}/discounts"
      within "#discount-#{@discount1.id}" do
        click_link "View"
        expect(current_path).to eq("/merchants/#{@merch_2.id}/discounts/#{@discount1.id}")
      end
  end

  it 'lists the next 3 holidays' do
    visit "/merchants/#{@merch_2.id}/discounts"
    save_and_open_page
  end


end

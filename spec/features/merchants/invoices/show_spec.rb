require "rails_helper"

RSpec.describe "merchant's invoice show page", type: :feature do
  before :each do
    @merch_1 = Merchant.create!(name: "Two-Legs Fashion")

    @item_1 = @merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
    @item_2 = @merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)

    @cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
    @cust_2 = Customer.create!(first_name: "Tommy", last_name: "Doubleleg")

    @invoice_1 = @cust_1.invoices.create!(status: 1)
    @invoice_2 = @cust_1.invoices.create!(status: 2)
    @invoice_3 = @cust_1.invoices.create!(status: 1)
    @invoice_4 = @cust_2.invoices.create!(status: 1)
    @invoice_5 = @cust_2.invoices.create!(status: 1)
    @invoice_6 = @cust_2.invoices.create!(status: 1, created_at: "2021-05-29 17:44:03 UTC")

    @ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_1.unit_price, status: 0)
    @ii_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 2, unit_price: @item_2.unit_price, status: 1)
  end

  it "shows invoice ID, invoice status, created at time formatted and customer name" do
    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id})"

    expect(page).to have_content("Invoice ID: #{@invoice_1.id}")
    expect(page).to have_content("Status: in progress")
    expect(page).to have_content("#{@invoice_1.created_at.strftime( "%A, %b %e, %Y")}")
    expect(page).to have_content("Debbie Twolegs")

    expect(page).to_not have_content("#{@invoice_2.id}")
    expect(page).to_not have_content("#{@invoice_2.status}")
    expect(page).to_not have_content("#{@invoice_6.created_at}")
    expect(page).to_not have_content("Tommy Doubleleg")
  end

  it "shows item name, quantity, price, status from just this merchant" do
    merch = Merchant.create!(name: "Pants Pants Pants")
    item = merch.items.create!(name: "Test", description: "test", unit_price: 1000)

    invoice_item = InvoiceItem.create!(item_id: item.id, invoice_id: @invoice_1.id, quantity: 6, unit_price: item.unit_price, status: 1)

    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id})"
    expect(page).to have_content("Two-Leg Pantaloons")
    expect(page).to have_content("Quantity: 1")
    expect(page).to have_content("Unit Price: $50.00")
    expect(find_field('ii_status').value).to eq("packaged")

    expect(page).to_not have_content("Two-Leg Shorts")
    expect(page).to_not have_content("Quantity: 2")
    expect(page).to_not have_content("Unit Price: $30.00")

    expect(page).to_not have_content("test")
    expect(page).to_not have_content("Quantity: 6")
    expect(page).to_not have_content("Unit Price: $10.00")
  end

  it "Shows sum of all items sold in receipt" do
    @item_3 = @merch_1.items.create!(name: "Hat", description: "hat built for people with two legs and one head", unit_price: 6000)
    @item_4 = @merch_1.items.create!(name: "Double Legged Pant", description: "pants built for people with two legs", unit_price: 50000)
    @ii_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_3.unit_price, status: 2)
    @ii_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_4.unit_price, status: 2)


    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id})"
    expect(page).to have_content("Total Revenue: $610.00")
  end

  it "can change the invoice status" do
    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
    #within the first item section
      within "#ii-#{@ii_1.id}" do
        expect(find_field('ii_status').value).to eq("packaged")
        select "pending"
        click_button "Update Invoice"
        expect(current_path).to eq( "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}" )
        expect(page).to have_content('pending')
      end
  end

  it "shows the discounted revenue" do
    @merch_1.discounts.create!(percentage: 50, quantity: 10)
    @merch_1.discounts.create!(percentage: 10, quantity: 5)
    InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: @item_1.unit_price, status: 2)
    InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 10, unit_price: @item_2.unit_price, status: 2)
    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
    expect(page).to have_content("Discounted Revenue: $425.00")
  end

  it "shows the discounted revenue as total revenue if no discount threshold is met" do
    @merch_1.discounts.create!(percentage: 10, quantity: 5)
    @merch_1.discounts.create!(percentage: 50, quantity: 10)
    InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_1.unit_price, status: 2)
    InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_6.id, quantity: 1, unit_price: @item_2.unit_price, status: 2)

    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_6.id}"
    expect(page).to have_content("Discounted Revenue: $80.00")
  end

  it "has a view discount link next to invoice items with discounts" do
    @merch_1.discounts.create!(percentage: 10, quantity: 5)
    @merch_1.discounts.create!(percentage: 50, quantity: 10)
    ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: @item_1.unit_price, status: 2)
    ii_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_2.unit_price, status: 2)
    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
    within "#ii-#{ii_1.id}" do
      expect(page).to have_link("View Discount Applied")
    end
    within "#ii-#{ii_2.id}" do
      expect(page).to_not have_link("View Discount Applied")
    end
  end

  it "has a view discount link next to invoice items with discounts" do
    discount = @merch_1.discounts.create!(percentage: 10, quantity: 5)
    @merch_1.discounts.create!(percentage: 50, quantity: 10)
    ii_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 5, unit_price: @item_1.unit_price, status: 2)
    ii_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: @item_2.unit_price, status: 2)
    visit "/merchants/#{@merch_1.id}/invoices/#{@invoice_1.id}"
    within "#ii-#{ii_1.id}" do
      click_link "View Discount Applied"
    end
    expect(current_path).to eq("/discounts/#{discount.id}")
  end
end

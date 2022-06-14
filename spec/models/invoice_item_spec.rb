require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'associations' do
    it { should belong_to :item}
    it { should belong_to :invoice}
  end

  describe 'validations' do
    it { should validate_presence_of :quantity}
    it { should validate_presence_of :unit_price}
    it { should define_enum_for(:status).with_values(['packaged', 'pending', 'shipped'])}
  end

  describe 'class methods' do
    it "#discount_applied" do
      merch_1 = Merchant.create!(name: "Two-Legs Fashion")
      item_1 = merch_1.items.create!(name: "Two-Leg Pantaloons", description: "pants built for people with two legs", unit_price: 5000)
      item_2 = merch_1.items.create!(name: "Two-Leg Shorts", description: "shorts built for people with two legs", unit_price: 3000)
      discount = merch_1.discounts.create!(percentage: 10, quantity: 5)
      cust_1 = Customer.create!(first_name: "Debbie", last_name: "Twolegs")
      invoice_1 = cust_1.invoices.create!(status: 1)
      merch_1.discounts.create!(percentage: 50, quantity: 10)
      ii_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 5, unit_price: item_1.unit_price, status: 2)
      ii_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: item_2.unit_price, status: 2)

      expect(ii_1.discount_applied).to eq(discount.id)
    end
  end
end
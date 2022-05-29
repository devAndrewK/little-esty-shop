class Item < ApplicationRecord
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price

  def unit_price_to_dollars
    self.unit_price / 100.00
  end

  def merchant_object
    Merchant.find(self.merchant_id)
  end
end
class AddDiscountToInvoiceItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoice_items, :discount, foreign_key: true
  end
end

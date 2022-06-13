class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: ['cancelled','in progress', 'completed']

  validates :status, inclusion: { in: statuses.keys }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue(merchant)
    merchant.invoice_items.joins(:discounts)
            .where('invoice_items.quantity >= discounts.quantity')
            .select('invoice_items.id, max(invoice_items.quantity * invoice_items.unit_price * (discounts.percentage / 100.0)) as total_discount')
            .group('invoice_items.id')
            .sum(&:total_discount)
  end

  def self.incomplete_invoices_ordered
    Invoice.joins(:invoice_items).where(invoice_items: { status: [0, 1] }).order(:created_at).distinct
  end

  def merchant_object(id)
    Merchant.find(id)
  end
end

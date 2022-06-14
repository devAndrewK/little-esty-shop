class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

  validates_presence_of :quantity, :unit_price

  enum status: ['packaged', 'pending', 'shipped']

  validates :status, inclusion: { in: statuses.keys }

  before_create :discount_applied

  def discount_applied
    greatest_discount = discounts.where('discounts.quantity <= ?', quantity)
    .select('discounts.id, max(discounts.percentage)')
    .group('discounts.id')
    .first

    if !greatest_discount.nil?
      self.discount_id = greatest_discount.id
    end
  end
end
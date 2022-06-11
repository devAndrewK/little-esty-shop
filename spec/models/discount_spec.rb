require 'rails_helper'

RSpec.describe Discount do
  describe 'associations' do
    it { should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of :percentage}
    it { should validate_presence_of :quantity}
  end
end

require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do

  describe 'associations' do
	it {should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than(0) } 
    it { should validate_presence_of(:discount) }
    it { should validate_numericality_of(:discount).is_greater_than_or_equal_to(0.01) }
    it { should validate_numericality_of(:discount).is_less_than_or_equal_to(0.99) }
  end

end
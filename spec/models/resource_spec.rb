require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'Associations' do
    it { should have_many(:inventory_resources) }
    it { should have_many(:inventories).through(:inventory_resources) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:item) }
    it { should validate_presence_of(:value) }
    it { should validate_uniqueness_of(:item).case_insensitive }
  end
end

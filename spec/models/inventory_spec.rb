require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'Associations' do
    it { should belong_to(:survivor) }
    it { should have_many(:inventory_resources) }
    it { should have_many(:resources).through(:inventory_resources) }
    it { should accept_nested_attributes_for(:inventory_resources) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:survivor) }
  end

end

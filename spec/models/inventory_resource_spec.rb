require 'rails_helper'

RSpec.describe InventoryResource, type: :model do
  describe 'Associations' do
    it { should belong_to(:inventory) }
    it { should belong_to(:resource) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:inventory) }
  end
end

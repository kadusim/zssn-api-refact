require 'rails_helper'

RSpec.describe Survivor, type: :model do
  describe 'Associations' do
    it { should have_one(:inventory) }
    it { should have_many(:inventory_resources).through(:inventory) }
    it { should have_many(:infected_reports) }
    it { should accept_nested_attributes_for(:inventory) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
  end
end

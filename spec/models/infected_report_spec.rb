require 'rails_helper'

RSpec.describe InfectedReport, type: :model do
  describe 'Associations' do
    it { should belong_to(:survivor) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:survivor_id) }
    it { should validate_presence_of(:reporter_id) }
  end
end

require 'rails_helper'

RSpec.describe 'Request Resources', type: :request do

  let!(:resource_water)      { create(:resource_water) }
  let!(:resource_food)       { create(:resource_food) }
  let!(:resource_medication) { create(:resource_medication) }
  let!(:resource_ammunition) { create(:resource_ammunition) }

  # Test suite for GET api/resources
  describe 'GET /api/resources' do
    before { get '/api/resources' }

    it 'returns survivors' do
      expect(json).not_to be_empty
      expect(json.size).to eq(4)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end
end

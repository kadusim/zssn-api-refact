require 'rails_helper'

RSpec.describe 'Request Exchanges', type: :request do

  let!(:water)       {create(:resource_water)}
  let!(:food)        {create(:resource_food)}
  let!(:medication)  {create(:resource_medication)}
  let!(:ammunition)  {create(:resource_ammunition)}

  let(:survivor_one) {create(:survivor_without_resources)}
  let(:survivor_two) {create(:survivor_without_resources)}

  before :each {
    survivor_one.inventory.inventory_resources.create!([
      {resource: medication},
      {resource: ammunition},
      {resource: ammunition},
      {resource: ammunition}
    ])

    survivor_two.inventory.inventory_resources.create!([
      {resource: water},
      {resource: water}
    ])
  }

  let(:exchange_params) do
    {
      exchanges: {
        survivor_one: {
          id: survivor_one.id,
          resources: [
            {
              resource_id: ammunition.id,
              quantity: 2
            },
            {
              resource_id: medication.id,
              quantity: 1
            }
          ]
        },
        survivor_two: {
          id: survivor_two.id,
          resources: [
            {
              resource_id: water.id,
              quantity: 1
            }
          ]
        }
      }
    }
  end

  # Test suite for POST /api/exchanges
  describe 'POST /api/exchanges' do

    context "when survivors does not exist" do
      before {
        exchange_params[:exchanges][:survivor_one][:id] = '10000'
        post '/api/exchanges', params: exchange_params
      }

      it 'returns status code 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'returns message Couldnt find Survivor' do
        expect(response.body).to match(/Couldn't find Survivor with 'id'=#{exchange_params[:exchanges][:survivor_one][:id]}/)
      end
    end

    context "when survivors infected" do
      before {
        survivor_one.update_attribute(:infected, true)
        post '/api/exchanges', params: exchange_params
      }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns message is infected' do
        expect(response.body).to match(/Be careful, survivor id: #{survivor_one.id} is infected/)
      end
    end

    context "when survivors no have enough resources" do
      before {
        exchange_params[:exchanges][:survivor_one][:resources][0][:quantity] = 10
        post '/api/exchanges', params: exchange_params
      }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns message no have enough resources for exchange' do
        expect(response.body).to match(/Survivor id: #{survivor_one.id} no have enough resources for exchange/)
      end
    end

    context "when survivors not matchings resources points" do
      before {
        exchange_params[:exchanges][:survivor_one][:resources][0][:quantity] = 3
        post '/api/exchanges', params: exchange_params
      }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns message an exchange must be made with the same amount of points' do
        expect(response.body).to match(/An exchange must be made with the same amount of points/)
      end
    end

    context "when survivors can make the exchange" do
      before {
        post '/api/exchanges', params: exchange_params
      }

      it 'returns status code 201' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns message successful exchange' do
        expect(response.body).to match(/Successful exchange/)
      end

      it 'survivor one inventory with changed resources' do
        survivor_one.inventory_resources.reload
        expect(survivor_one.inventory.resources.size).to eq(2)
        expect(survivor_one.inventory.resources).to match_array([water, ammunition])
      end

      it 'survivor two inventory with changed resources' do
        expect(survivor_two.inventory.resources.size).to eq(4)
        expect(survivor_two.inventory.resources).to match_array([water, ammunition, ammunition, medication])
      end
    end

  end

end

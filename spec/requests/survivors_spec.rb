require 'rails_helper'

RSpec.describe 'Request Survivors', type: :request do

  let!(:survivors)           { create_list(:survivor, 10) }
  let(:survivor_id)          { survivors.first.id }

  let!(:resource_water)      { create(:resource_water) }
  let!(:resource_food)       { create(:resource_food) }
  let!(:resource_medication) { create(:resource_medication) }
  let!(:resource_ammunition) { create(:resource_ammunition) }

  # Test suite for GET api/survivors
  describe 'GET /api/survivors' do
    before { get '/api/survivors' }

    it 'returns survivors' do
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

  end

  # Test suite for GET api/survivors/:id
  describe 'GET /api/survivors/:id' do
    before { get "/api/survivors/#{survivor_id}" }

    context 'when the record exists' do
      it 'returns the survivor' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(survivor_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:survivor_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Survivor/)
      end
    end

  end

  # Test suite for POST api/survivors
  describe 'POST /api/survivors' do
    let(:survivor) { build(:survivor) }

    context 'when the request is valid' do

      before {
        post '/api/survivors', params: {
          survivor: {
            name:      survivor.name,
            age:       survivor.age,
            gender:    survivor.gender,
            latitude:  survivor.latitude,
            longitude: survivor.longitude,
            infected:  survivor.infected,
            inventory_attributes: {
              inventory_resources_attributes: [
                { resource_id: resource_water.id },
                { resource_id: resource_food.id },
                { resource_id: resource_food.id },
                { resource_id: resource_medication.id },
                { resource_id: resource_ammunition.id }
              ]
            }
          }
        }
      }

      it 'creates a survivor' do
        expect(json['name']).to           eq(survivor.name)
        expect(json['age']).to            eq(survivor.age)
        expect(json['gender']).to         eq(survivor.gender)
        expect(json['latitude'].to_d).to  eq(survivor.latitude)
        expect(json['longitude'].to_d).to eq(survivor.longitude)
        expect(json['infected']).to       eq(survivor.infected)
      end

      it 'creates resources' do
        expect(Survivor.last.inventory.resources.size).to eq(5)
        expect(Survivor.last.inventory.resources).to match_array([resource_water, resource_food, resource_food, resource_medication, resource_ammunition])
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/survivors', params: { survivor: { name: survivor.name } } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Age can't be blank/)
        expect(response.body).to match(/Gender can't be blank/)
        expect(response.body).to match(/Latitude can't be blank/)
        expect(response.body).to match(/Longitude can't be blank/)
      end
    end

  end

  # Test suite for PUT api/survivors/:id
  describe 'PUT /api/survivors/:id' do
    let(:survivor) { build(:survivor) }

    context 'when the record exists' do

      before {
        put "/api/survivors/#{survivor_id}", params: {
          survivor: {
            latitude:  survivor.latitude,
            longitude: survivor.longitude
          }
        }
      }

      it 'updates a survivor' do
        expect(Survivor.find(survivor_id).latitude).to  eq(survivor.latitude)
        expect(Survivor.find(survivor_id).longitude).to eq(survivor.longitude)
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the request is invalid' do
      before {
        put "/api/survivors/#{survivor_id}", params: {
          survivor: {
            name:  survivor.name
          }
        }
      }

      it 'unpermitted updates name' do
        expect(Survivor.last.name).not_to eq(survivor.name)
      end
    end

    context 'when the survivor not exists' do
      before {
        put "/api/survivors/#{100000}", params: {
          survivor: {
            latitude:  survivor.latitude,
            longitude: survivor.longitude
          }
        }
      }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

  end

end

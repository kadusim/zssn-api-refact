require 'rails_helper'

RSpec.describe 'Request Reports', type: :request do

  before :each {
    water              = create(:resource_water)
    food               = create(:resource_food)
    medication         = create(:resource_medication)
    ammunition         = create(:resource_ammunition)
    survivors          = create_list(:survivor_without_resources, 5)
    survivors_infected = create_list(:survivor_infected_without_resources, 5)

    survivors.each do |survivor|
      survivor.inventory.inventory_resources.create!([
        {resource: water},
        {resource: food},
        {resource: medication},
        {resource: ammunition}
      ])
    end

    survivors_infected.each do |survivor|
      survivor.inventory.inventory_resources.create!([
        {resource: water},
        {resource: food},
        {resource: medication},
        {resource: ammunition}
      ])
    end
  }

  # Test suite for GET /api/reports/percentage_infected_survivors
  describe 'GET /api/reports/percentage_infected_survivors' do

    context "when there are infected survivors" do
      before {
        get '/api/reports/percentage_infected_survivors'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns percentage' do
        expect(json['percentage']).to eq '50.0'
      end
    end

    context "when there are no infected survivors" do
      before {
        DatabaseCleaner.clean
        get '/api/reports/percentage_infected_survivors'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns No survivors found' do
        expect(json['message']).to eq 'No survivors found'
      end
    end
  end

  # Test suite for GET /api/reports/percentage_non_infected_survivors
  describe 'GET /api/reports/percentage_non_infected_survivors' do


    context "when there are infected survivors" do
      before {
        get '/api/reports/percentage_non_infected_survivors'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns percentage' do
        expect(json['percentage']).to eq '50.0'
      end
    end

    context "when there are no infected survivors" do
      before {
        DatabaseCleaner.clean
        get '/api/reports/percentage_non_infected_survivors'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns No survivors found' do
        expect(json['message']).to eq 'No survivors found'
      end
    end
  end

  # Test suite for GET /api/reports/average_resources_by_survivor
  describe 'GET /api/reports/average_resources_by_survivor' do

    context "when there are survivors" do
      before {
        get '/api/reports/average_resources_by_survivor'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns quantity items per survivor' do
        expect(json['averages']['water']).to      eq 1
        expect(json['averages']['food']).to       eq 1
        expect(json['averages']['medication']).to eq 1
        expect(json['averages']['ammunition']).to eq 1
      end
    end

    context "when there are no survivors" do
      before {
        DatabaseCleaner.clean
        get '/api/reports/average_resources_by_survivor'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns No survivors found' do
        expect(json['message']).to eq 'No survivors found'
      end
    end
  end

  # Test suite for GET /api/reports/points_lost_because_infected
  describe 'GET /api/reports/points_lost_because_infected' do

    context "when there are survivors" do
      before {
        get '/api/reports/points_lost_because_infected'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns points lost because infected' do
        expect(json['points_lost']).to eq 50
      end
    end

    context "when there are no survivors" do
      before {
        DatabaseCleaner.clean
        get '/api/reports/points_lost_because_infected'
      }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns No survivors found' do
        expect(json['message']).to eq 'No survivors found'
      end
    end
  end

end

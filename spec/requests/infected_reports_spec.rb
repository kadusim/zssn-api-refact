require 'rails_helper'

RSpec.describe 'Request InfectedReports', type: :request do

  # Test suite for PUT /api/infected_report
  describe 'PUT /api/infected_report' do
    let(:survivor) { create(:survivor) }
    let(:reporter) { create(:survivor) }
    let(:survivor_infected) { create(:survivor_infected) }
    let(:reporter_infected) { create(:survivor_infected) }

    context 'when the survivor and reporter exists' do
      before {
        expect {
          post "/api/infected_report", params: {
            survivor_id: survivor.id,
            reporter_id: reporter.id
          }
        }.to change(InfectedReport, :count).by(1)
      }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Survivor reported successfully/)
      end
    end

    context 'when a reporter has already reported the survivor' do
      before {
        expect {
          post "/api/infected_report", params: {
            survivor_id: survivor.id,
            reporter_id: reporter.id
          }
        }.to change(InfectedReport, :count).by(1)

        expect {
          post "/api/infected_report", params: {
            survivor_id: survivor.id,
            reporter_id: reporter.id
          }
        }.to change(InfectedReport, :count).by(0)
      }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end

    context 'when the survivor does not exist' do
      let(:survivor_id_not_registered) { 1000 }

      before {
        post "/api/infected_report", params: {
          survivor_id: survivor_id_not_registered,
          reporter_id: reporter.id
        }
      }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Survivor/)
      end
    end

    context 'when the reporter does not exist' do
      let(:reporter_id_not_registered) { 1000 }

      before {
        post "/api/infected_report", params: {
          survivor_id: survivor.id,
          reporter_id: reporter_id_not_registered
        }
      }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Survivor/)
      end
    end

    context 'when the survivor was infected' do
      before {
        post "/api/infected_report", params: {
          survivor_id: survivor_infected.id,
          reporter_id: reporter.id
        }
      }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when a survivor becomes infected' do
      let(:reporter_two)  { create(:survivor) }
      let(:reporter_tree) { create(:survivor) }

      before {
        post "/api/infected_report", params: {
          survivor_id: survivor.id,
          reporter_id: reporter.id
        }
        post "/api/infected_report", params: {
          survivor_id: survivor.id,
          reporter_id: reporter_two.id
        }
        post "/api/infected_report", params: {
          survivor_id: survivor.id,
          reporter_id: reporter_tree.id
        }
      }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
        survivor.reload
        expect(survivor.infected).to be(true)
      end
    end
  end

end

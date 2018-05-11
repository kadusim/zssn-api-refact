class SurvivorsController < ApplicationController

  before_action :set_survivor, only: [:show, :update]

  api :GET, 'api/survivors', 'List Survivors'
  def index
    @survivors = Survivor.all
    json_response(@survivors)
  end

  api :POST, 'api/survivors', 'Add Survivors'
  def create
    @survivor = Survivor.create!(survivor_params)
    json_response(@survivor, :created)
  end

  api :GET, '/api/survivors/:id', 'Return survivor'
  def show
    json_response(@survivor)
  end

  api :PATH, 'api/survivors/:id', 'Update Survivor Location'
  api :PUT, 'api/survivors/:id', 'Update Survivor Location'
  def update
    @survivor.update(survivor_update_params)
    head :no_content
  end

  private

  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(:id, :name, :age, :gender, :latitude, :longitude, :infected,
      inventory_attributes: {
        inventory_resources_attributes: [
          :resource_id
        ]
      }
    )
  end

  def survivor_update_params
    params.require(:survivor).permit(:id, :latitude, :longitude)
  end

end

class ResourcesController < ApplicationController

  api :GET, 'api/resources', 'List Resources'
  def index
    @resources = Resource.all
    json_response(@resources)
  end

end

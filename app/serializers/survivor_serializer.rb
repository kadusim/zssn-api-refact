class SurvivorSerializer < ActiveModel::Serializer
  attributes :id, :name, :age, :gender, :latitude, :longitude, :infected, :resources

  def resources
    object.inventory_resources.map { |inventory_resource| inventory_resource.resource }
  end

end

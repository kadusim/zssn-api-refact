class InventoryResource < ApplicationRecord
  belongs_to :inventory
  belongs_to :resource, optional: true

  validates :inventory, presence: true

  class << self

    def delete_resources!(resource_id:, resource_quantity:)
      resources_to_delete = self.where(resource_id: resource_id).limit(resource_quantity)
      resources_to_delete.destroy_all
    end

    def add_resources!(resource_id:, resource_quantity:)
      resource = Resource.find_by_id(resource_id)
      resource_quantity.times do
        self.create(resource: resource)
      end
    end
  end

end

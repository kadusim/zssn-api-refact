class InventoryResource < ApplicationRecord
  belongs_to :inventory
  belongs_to :resource, optional: true

  validates :inventory, presence: true
end

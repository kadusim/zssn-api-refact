class Inventory < ApplicationRecord
  belongs_to :survivor
  has_many   :inventory_resources
  has_many   :resources, through: :inventory_resources
  accepts_nested_attributes_for :inventory_resources

  validates :survivor, presence: true
end

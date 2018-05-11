class Resource < ApplicationRecord
  has_many :inventory_resources
  has_many :inventories, through: :inventory_resources

  validates :item, :value, presence: true
  validates :item, uniqueness: { case_sensitive: false }
end

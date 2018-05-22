class Survivor < ApplicationRecord
  has_one  :inventory
  has_many :inventory_resources, through: :inventory
  has_many :infected_reports

  accepts_nested_attributes_for :inventory

  validates :name, :age, :gender, :latitude, :longitude, presence: true

  MAX_LIMITS_REPORT = 3

  def maximum_reporting_limit_reached?
    self.infected_reports.count >= MAX_LIMITS_REPORT
  end

  scope :total_survivors,               -> { count }
  scope :total_survivors_infecteds,     -> { where(infected: true).count }
  scope :total_survivors_non_infecteds, -> { where(infected: false).count }
  scope :survivors_infecteds,           -> { where(infected: true) }

  class << self

    def total_percentage_infected_survivors
      percentage_value_json(total_survivors_infecteds)
    end

    def total_percentage_non_infected_survivors
      percentage_value_json(total_survivors_non_infecteds)
    end

    def total_average_resources_by_survivor
      calculate_average_resources_in_inventories
    end

    def total_points_lost_because_infected
      calculate_points_lost_because_infected
    end

    private

    def percentage_value_json(quantity_survivors)
      quantity_survivors.percent_of(total_survivors).to_s
    end

    def calculate_average_resources_in_inventories
      resources = Resource.all_resources
      average_resources_in_inventories = {}

      resources.each do |resource|
        quantity_resource_in_inventories = InventoryResource.where(resource_id: resource.id).count
        average_resources_in_inventories[resource.item] = quantity_resource_in_inventories / total_survivors
      end
      average_resources_in_inventories
    end

    def calculate_points_lost_because_infected
      total_points = 0
      survivors_infecteds.map do |survivor|
        survivor.inventory.resources.map { |item| total_points += item.value }
      end
      total_points
    end

  end

end

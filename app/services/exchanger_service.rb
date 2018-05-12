class ExchangerService < ApplicationService
  attr_reader :resources, :survivor_one, :survivor_two, :survivors_change_resources

  def initialize(exchange_parms)
    @resources                     = Resource.all

    @survivor_one                  = Survivor.find(exchange_parms[:survivor_one][:id])
    @survivor_two                  = Survivor.find(exchange_parms[:survivor_two][:id])
    @survivors_change_resources    = exchange_parms[:survivor_one], exchange_parms[:survivor_two]
  end

  def call
    exchange! if survivors_can_exchange_resources?
  end

  private

  def exchange!
    InventoryResource.transaction do
      survivor_one_change_resources = survivors_change_resources[0][:resources]
      survivor_two_change_resources = survivors_change_resources[1][:resources]
      exchange_resources!(survivor_change_resources: survivor_one_change_resources, survivor_of: survivor_one, survivor_to: survivor_two)
      exchange_resources!(survivor_change_resources: survivor_two_change_resources, survivor_of: survivor_two, survivor_to: survivor_one)
    end
  end

  def survivors_can_exchange_resources?
    check_survivors_infected
    check_survivors_have_enough_resources
    check_survivors_values_items_matching(sum_points_resources_change)

    return true
  end

  def check_survivors_infected
    survivors.each do |survivor|
      if survivor.infected?
        raise ExceptionHandler::SurviroIsInfected, ("Be careful, survivor id: #{survivor.id} is infected")
      end
    end
  end

  def check_survivors_have_enough_resources
    survivors.each_with_index do |survivor, index|
      check_enough_resources(survivor, index)
    end
  end

  def check_enough_resources(survivor, index)
    survivors_change_resources[index][:resources].each do |resource_change|

      quantity_resources_change    = resource_change[:quantity].to_i
      quantity_resources_inventory = survivor.inventory_resources.where(resource_id: resource_change[:resource_id]).count

      if quantity_resources_change > quantity_resources_inventory
        raise ExceptionHandler::NoHaveEnoughResources, ("Survivor id: #{survivor.id} no have enough resources for exchange")
      end

    end
  end

  def sum_points_resources_change
    resources_survivors_total_values = [0, 0]

    survivors.each_with_index do |survivor, index|

      survivors_change_resources[index][:resources].each do |resource_change|
        resource_value                           = resources.find(resource_change[:resource_id]).value
        resources_survivors_total_values[index] += resource_change[:quantity].to_i * resource_value
      end

    end

    resources_survivors_total_values
  end

  def check_survivors_values_items_matching(resources_survivors_total_values)
    if resources_survivors_total_values[0] != resources_survivors_total_values[1]
      raise ExceptionHandler::ResourcesNotMatching, ("An exchange must be made with the same amount of points")
    end
  end

  def exchange_resources!(survivor_change_resources:, survivor_of:, survivor_to:)
    survivor_change_resources.each do |resource_change|
      resource_id       = resource_change[:resource_id].to_i
      resource_quantity = resource_change[:quantity].to_i

      resources_deleted = survivor_of.inventory_resources.where(resource_id: resource_id).limit(resource_quantity)

      resources_deleted.destroy_all

      resource_included = resources.find(resource_id)
      resource_quantity.times do
        survivor_to.inventory.inventory_resources.create!({resource: resource_included})
      end
    end
  end

  def survivors
    [survivor_one, survivor_two]
  end

end

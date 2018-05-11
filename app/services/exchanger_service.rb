class ExchangerService
  attr_reader :exchange_parms, :resources, :survivor_one, :survivor_two, :survivor_one_change_resources, :survivor_two_change_resources

  def initialize(exchange_parms)
    @exchange_parms                = exchange_parms
    @resources                     = Resource.all

    @survivor_one                  = Survivor.find(exchange_parms[:survivor_one][:id])
    @survivor_one_change_resources = exchange_parms[:survivor_one][:resources]

    @survivor_two                  = Survivor.find(exchange_parms[:survivor_two][:id])
    @survivor_two_change_resources = exchange_parms[:survivor_two][:resources]
  end

  def call
    exchange! if survivors_can_exchange_resources?
  end

  private

  def exchange!
    InventoryResource.transaction do
      exchange_resources!(survivor_change_resources: survivor_one_change_resources, survivor_of: survivor_one, survivor_to: survivor_two)
      exchange_resources!(survivor_change_resources: survivor_two_change_resources, survivor_of: survivor_two, survivor_to: survivor_one)
    end
  end

  def survivors_can_exchange_resources?
    check_survivors_infected(survivor_one)
    check_survivors_infected(survivor_two)

    check_survivors_have_enough_items(survivor_one_change_resources, survivor_one)
    check_survivors_have_enough_items(survivor_two_change_resources, survivor_two)

    total_points_survivor_one = sum_points_resources_change(survivor_one_change_resources, survivor_two)
    total_points_survivor_two = sum_points_resources_change(survivor_two_change_resources, survivor_two)

    check_survivors_values_items_matching(total_points_survivor_one, total_points_survivor_two)
    return true
  end

  def check_survivors_infected(survivor)
    if survivor.infected?
      raise ExceptionHandler::SurviroIsInfected, ("Be careful, survivor id: #{survivor.id} is infected")
    end
  end

  def check_survivors_have_enough_items(survivor_change_resources, survivor)
    survivor_change_resources.each do |resource_change|

      quantity_resources_change    = resource_change[:quantity].to_i
      quantity_resources_inventory = survivor.inventory_resources.where(resource_id: resource_change[:resource_id]).count

      if quantity_resources_change > quantity_resources_inventory
        raise ExceptionHandler::NoHaveEnoughResources, ("Survivor id: #{survivor.id} no have enough resources for exchange")
      end

    end
  end

  def sum_points_resources_change(survivor_change_resources, survivor)
    resources_survivor_total_value = 0

    survivor_change_resources.map do |resource_change|
      resource_value                  = resources.find(resource_change[:resource_id]).value
      resources_survivor_total_value += resource_change[:quantity].to_i * resource_value
    end

    resources_survivor_total_value
  end

  def check_survivors_values_items_matching(total_points_survivor_one, total_points_survivor_two)
    if total_points_survivor_one != total_points_survivor_two
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

end

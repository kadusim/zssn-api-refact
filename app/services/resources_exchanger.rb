class ResourcesExchanger
  attr :resources, :survivor_one, :survivor_two, :survivors_change_resources, :values_resources_total

  def initialize(exchange_parms)
    @resources                          = Resource.all_resources

    @survivor_one                       = Survivor.find(exchange_parms[:survivor_one][:id])
    @survivor_two                       = Survivor.find(exchange_parms[:survivor_two][:id])

    @survivors_change_resources         = exchange_parms[:survivor_one], exchange_parms[:survivor_two]

    @values_resources_total             = [0, 0]
    sum_resources
  end

  def validations_exchange_resources
    check_survivors_infected
    check_survivors_have_enough_resources
    check_survivors_values_items_matching
    exchange
  end

  private

  def check_survivors_infected
    survivors.each do |survivor|
      if survivor.infected?
        raise ExceptionHandler::SurviroIsInfected, ("Be careful, survivor id: #{survivor.id} is infected")
      end
    end
  end
  
  def check_survivors_have_enough_resources
    survivors.each_with_index do |survivor, index|

      survivors_change_resources[index][:resources].each do |resource_change|

        resource_id                  = resource_change[:resource_id]

        quantity_resources_change    = resource_change[:quantity].to_i
        quantity_resources_inventory = survivor.inventory.inventory_resources.where(resource_id: resource_id).count

        if quantity_resources_change > quantity_resources_inventory
          raise ExceptionHandler::NoHaveEnoughResources, ("Survivor id: #{survivor.id} no have enough resources for exchange")
        end

      end

    end
  end

  def check_survivors_values_items_matching
    if resources_total_value_survivor_one != resources_total_value_survivor_two 
      raise ExceptionHandler::ResourcesNotMatching, ("An exchange must be made with the same amount of points")
    end
  end

  def exchange
    InventoryResource.transaction do
      begin
        exchange_resources(survivor_change_resources: survivor_one_exchange_resources, survivor_of: survivor_one, survivor_to: survivor_two)
        exchange_resources(survivor_change_resources: survivor_two_exchange_resources, survivor_of: survivor_two, survivor_to: survivor_one)
      rescue Exception => message_error
        raise ExceptionHandler::ExchangeServiceError, (message_error)
      end
      return true
    end
  end

  private

  def exchange_resources(survivor_change_resources:, survivor_of:, survivor_to:)
    survivor_change_resources.each do |resource_change|
      resource_id       = resource_change[:resource_id].to_i
      resource_quantity = resource_change[:quantity].to_i

      survivor_of.inventory.inventory_resources.delete_resources!(resource_id: resource_id, resource_quantity: resource_quantity)

      survivor_to.inventory.inventory_resources.add_resources!(resource_id: resource_id, resource_quantity: resource_quantity)
    end
  end

  def sum_resources
    survivors.each_with_index do |survivor, index|

      survivors_change_resources[index][:resources].each do |resource_change|

        resource_id                                = resource_change[:resource_id]
        resource_value                             = resources.find(resource_id).value
        quantity_resource_change                   = resource_change[:quantity].to_i

        values_resources_total[index]             += quantity_resource_change * resource_value
      end

    end
  end

  def survivors
    [survivor_one, survivor_two]
  end

  def resources_total_value_survivor_one 
    values_resources_total[0]
  end

  def resources_total_value_survivor_two 
    values_resources_total[1]
  end

  def survivor_one_exchange_resources
    survivors_change_resources[0][:resources]
  end
  
  def survivor_two_exchange_resources
    survivors_change_resources[1][:resources]
  end

end


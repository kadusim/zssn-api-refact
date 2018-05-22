class ValidationsExchanger
  attr :exchanger_parms

  def initialize(exchanger_parms)
    @exchanger_parms = exchanger_parms
  end

  def validations_survivors_exchange_resources
    check_survivors_infected
    check_survivors_have_enough_resources
    check_survivors_values_items_matching
  end

  def check_survivors_infected
    exchanger_parms.survivors.each do |survivor|
      if survivor.infected?
        raise ExceptionHandler::SurviroIsInfected, ("Be careful, survivor id: #{survivor.id} is infected")
      end
    end
  end
  
  def check_survivors_have_enough_resources
    exchanger_parms.survivors.each_with_index do |survivor, index|

      exchanger_parms.survivors_change_resources[index][:resources].each do |resource_change|

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
    if exchanger_parms.resources_total_value_survivor_one != exchanger_parms.resources_total_value_survivor_two 
      raise ExceptionHandler::ResourcesNotMatching, ("An exchange must be made with the same amount of points")
    end
  end

end


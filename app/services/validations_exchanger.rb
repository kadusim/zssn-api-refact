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
    if exchanger_parms.quantity_resources_change_survivor_one > exchanger_parms.quantity_resources_inventory_survivor_one
      raise ExceptionHandler::NoHaveEnoughResources, ("Survivor id: #{exchanger_parms.survivor_one.id} no have enough resources for exchange")
    end

    if exchanger_parms.quantity_resources_change_survivor_two > exchanger_parms.quantity_resources_inventory_survivor_two
      raise ExceptionHandler::NoHaveEnoughResources, ("Survivor id: #{exchanger_parms.survivor_two.id} no have enough resources for exchange")
    end
  end

  def check_survivors_values_items_matching
    if exchanger_parms.resources_total_value_survivor_one != exchanger_parms.resources_total_value_survivor_two 
      raise ExceptionHandler::ResourcesNotMatching, ("An exchange must be made with the same amount of points")
    end
  end

end


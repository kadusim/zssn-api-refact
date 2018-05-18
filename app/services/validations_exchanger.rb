class ValidationsExchanger < Exchanger

  def initialize(exchange_parms)
    super
  end

  def validations_survivors_exchange_resources
    check_survivors_infected
    check_survivors_have_enough_resources
    check_survivors_values_items_matching(sum_points_resources_change)
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

      survivors_change_resources[index][:resources].each do |resource_change|

        quantity_resources_change    = resource_change[:quantity].to_i
        quantity_resources_inventory = survivor.inventory_resources.where(resource_id: resource_change[:resource_id]).count

        if quantity_resources_change > quantity_resources_inventory
          raise ExceptionHandler::NoHaveEnoughResources, ("Survivor id: #{survivor.id} no have enough resources for exchange")
        end

      end

    end
  end

  def sum_points_resources_change
    resources_survivors_total_values = [0, 0]

    survivors.each_with_index do |survivor, index|

      survivors_change_resources[index][:resources].each do |resource_change|
        resource_id                              = resource_change[:resource_id]
        quantity_resources_change                = resource_change[:quantity].to_i
        resource_value                           = resources.find(resource_id).value

        resources_survivors_total_values[index] += quantity_resources_change * resource_value
      end

    end

    resources_survivors_total_values
  end

  def check_survivors_values_items_matching(resources_survivors_total_values)
    resources_total_value_survivor_one = resources_survivors_total_values[0]
    resources_total_value_survivor_two = resources_survivors_total_values[1]

    if resources_total_value_survivor_one != resources_total_value_survivor_two 
      raise ExceptionHandler::ResourcesNotMatching, ("An exchange must be made with the same amount of points")
    end
  end

end


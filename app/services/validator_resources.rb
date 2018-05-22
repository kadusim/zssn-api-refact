class ValidatorResources < Exchanger
  attr :resources, :values_resources_total

  def initialize(exchange_parms)
    super
    @resources              = Resource.all_resources
    @values_resources_total = [0, 0]
    @values_resources_total = sum_resources
  end

  def validate
    check_survivors_infected
    check_survivors_have_enough_resources
    check_survivors_values_items_matching
  end

  private

  def sum_resources
    survivors.each_with_index do |survivor, index|

      survivors_change_resources[index][:resources].each do |resource_change|

        resource_id                                = resource_change[:resource_id]
        resource_value                             = resources.find(resource_id).value
        quantity_resource_change                   = resource_change[:quantity].to_i

        values_resources_total[index]             += quantity_resource_change * resource_value
      end

    end
    values_resources_total
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

  def resources_total_value_survivor_one 
    values_resources_total[0]
  end

  def resources_total_value_survivor_two 
    values_resources_total[1]
  end

end


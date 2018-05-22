class ExchangerParms
  attr_reader :resources, :survivor_one, :survivor_two, :survivors_change_resources, :values_resources_total

  def initialize(exchange_parms)
    @resources                          = Resource.all

    @survivor_one                       = Survivor.find(exchange_parms[:survivor_one][:id])
    @survivor_two                       = Survivor.find(exchange_parms[:survivor_two][:id])

    @survivors_change_resources         = exchange_parms[:survivor_one], exchange_parms[:survivor_two]

    @values_resources_total             = [0, 0]
    sum_resources
  end

  def survivor_one_exchange_resources
    survivors_change_resources[0][:resources]
  end
  
  def survivor_two_exchange_resources
    survivors_change_resources[1][:resources]
  end

  def resources_total_value_survivor_one 
    values_resources_total[0]
  end

  def resources_total_value_survivor_two 
    values_resources_total[1]
  end

  def survivors
    [survivor_one, survivor_two]
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
  end
    
end

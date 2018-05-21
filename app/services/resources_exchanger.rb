class ResourcesExchanger
  attr :exchanger_parms

  def initialize(exchanger_parms)
    @exchanger_parms = exchanger_parms
  end

  def exchange
    InventoryResource.transaction do
      begin
        exchange_resources(survivor_change_resources: exchanger_parms.survivor_one_exchange_resources, survivor_of: exchanger_parms.survivor_one, survivor_to: exchanger_parms.survivor_two)
        exchange_resources(survivor_change_resources: exchanger_parms.survivor_two_exchange_resources, survivor_of: exchanger_parms.survivor_two, survivor_to: exchanger_parms.survivor_one)
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

end

class ExchangerResources < Exchanger

  def initialize(exchange_parms)
    super
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

  def survivor_one_exchange_resources
    survivors_change_resources[0][:resources]
  end

  def survivor_two_exchange_resources
    survivors_change_resources[1][:resources]
  end

end


class ResourcesExchanger < Exchanger
  attr :resource_id, :resource_quantity

  def initialize(exchange_parms)
    super
  end

  def exchange
    InventoryResource.transaction do
      survivor_one_change_resources = survivors_change_resources[0][:resources]
      survivor_two_change_resources = survivors_change_resources[1][:resources]
      begin
        exchange_resources(survivor_change_resources: survivor_one_change_resources, survivor_of: survivor_one, survivor_to: survivor_two)
        exchange_resources(survivor_change_resources: survivor_two_change_resources, survivor_of: survivor_two, survivor_to: survivor_one)
      rescue Exception => message_error
        raise ExceptionHandler::ExchangeServiceError, (message_error)
      end
      return true
    end
  end

  private

  def exchange_resources(survivor_change_resources:, survivor_of:, survivor_to:)
    survivor_change_resources.each do |resource_change|
      @resource_id       = resource_change[:resource_id].to_i
      @resource_quantity = resource_change[:quantity].to_i

      delete_resources_of_inventory(survivor_of)

      add_resources_to_inventory(survivor_to)
    end
  end

  def delete_resources_of_inventory(survivor_of)
    survivor_of.inventory.inventory_resources.delete_resources!(resource_id: resource_id, resource_quantity: resource_quantity)
  end

  def add_resources_to_inventory(survivor_to)
    survivor_to.inventory.inventory_resources.add_resources!(resource_id: resource_id, resource_quantity: resource_quantity)
  end

end

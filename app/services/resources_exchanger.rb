class ResourcesExchanger < Exchanger
  attr_reader :resource_id, :resource_quantity

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

      delete_resources!(survivor_of)

      add_resources!(survivor_to)
    end
  end

  def delete_resources!(survivor_of)
    resources_deleted = survivor_of.inventory_resources.where(resource_id: resource_id).limit(resource_quantity)
    resources_deleted.destroy_all
  end

  def add_resources!(survivor_to)
    resource_included = resources.find(resource_id)
    resource_quantity.times do
      survivor_to.inventory.inventory_resources.create!({resource: resource_included})
    end
  end

end

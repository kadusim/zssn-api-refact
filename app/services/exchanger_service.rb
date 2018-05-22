class ExchangerService < ApplicationService
  attr :exchange_parms

  def initialize(exchange_parms)
    @exchange_parms = exchange_parms
  end

  def call
    resources_exchanger = ResourcesExchanger.new(exchange_parms)
    if resources_exchanger.validations_exchange_resources
      return true
    end
  end

end

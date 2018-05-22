class ExchangerService < ApplicationService
  attr :exchange_parms

  def initialize(exchange_parms)
    @exchange_parms = exchange_parms
  end

  def call
    validator_resources = ValidatorResources.new(exchange_parms)
    validator_resources.validate

    exchanger_resources = ExchangerResources.new(exchange_parms)
    if exchanger_resources.exchange
      return true
    end
  end

end

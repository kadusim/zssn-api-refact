class ExchangerService < ApplicationService
  attr_reader :exchange_parms

  def initialize(exchange_parms)
    @exchange_parms = exchange_parms
  end

  def call
    validations_exchanger = ValidationsExchanger.new(exchange_parms)
    validations_exchanger.validations_survivors_exchange_resources

    resources_exchanger = ResourcesExchanger.new(exchange_parms)
    return true if resources_exchanger.exchange
  end

end

class ExchangerService < ApplicationService
  attr :exchanger_parms

  def initialize(exchange_parms)
    @exchanger_parms = ExchangerParms.new(exchange_parms)
  end

  def call
    validations_exchanger = ValidationsExchanger.new(exchanger_parms)
    validations_exchanger.validations_survivors_exchange_resources

    resources_exchanger = ResourcesExchanger.new(exchanger_parms)
    if resources_exchanger.exchange
      return true
    end
  end

end

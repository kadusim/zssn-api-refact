class ExchangesController < ApplicationController

  api :POST, 'api/exchanges', 'Exchange Resources'
  def create
    if ExchangerService.call(exchange_parms)
      json_response({ message: 'Successful exchange' })
    end
  end

  private

  def exchange_parms
    params.require(:exchanges).permit(
      survivor_one: [ :id, resources: [ [:resource_id, :quantity] ] ],
      survivor_two: [ :id, resources: [ [:resource_id, :quantity] ] ]
    )
  end

end

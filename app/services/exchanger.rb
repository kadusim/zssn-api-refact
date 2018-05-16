class Exchanger
  attr_reader :resources, :survivor_one, :survivor_two, :survivors_change_resources

  def initialize(exchange_parms)
    @resources                     = Resource.all

    @survivor_one                  = Survivor.find(exchange_parms[:survivor_one][:id])
    @survivor_two                  = Survivor.find(exchange_parms[:survivor_two][:id])
    @survivors_change_resources    = exchange_parms[:survivor_one], exchange_parms[:survivor_two]
  end

  private

  def survivors
    [survivor_one, survivor_two]
  end

end

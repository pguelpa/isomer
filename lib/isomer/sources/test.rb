class Isomer::Sources::Test < Isomer::Sources::Base
  attr_accessor :payload

  def initialize(payload)
    @payload = payload
    super()
  end

  def load(parameters)
    @configuration = payload
  end
end
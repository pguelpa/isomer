class Isomer::Sources::Test < Isomer::Sources::Base
  attr_accessor :payload

  def initialize(payload, base = nil)
    @payload = payload
    super(base)
  end

  def load(parameters)
    if base && payload.has_key?(base)
      @configuration = payload[base]
    else
      @configuration = payload
    end
  end
end
class Isomer::Nucleus
  attr_reader :parameters

  def initialize
    @parameters = {}
    yield(self) if block_given?
  end

  def parameter(id, options = {})
    parameter = Isomer::Parameter.new(id, options)
    @parameters[id] = parameter
  end
end

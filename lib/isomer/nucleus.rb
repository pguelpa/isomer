class Isomer::Nucleus
  attr_reader :parameters

  def self.build
    configuration = self.new
    yield(configuration) if block_given?
    configuration
  end

  def initialize
    @parameters = {}
  end

  def parameter(id, options = {})
    parameter = Isomer::Parameter.new(id, options)
    @parameters[id] = parameter
  end
end

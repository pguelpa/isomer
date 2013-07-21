class Isomer::Sources::Base
  attr_reader :base, :configuration

  def initialize(base = nil)
    @base = base
  end

  def load(parameters)
    raise NotImplementedError, "You must implement 'load' in #{self.class.name}"
  end

  def for(parameter)
    configuration[parameter.name] || parameter.default
  end
end